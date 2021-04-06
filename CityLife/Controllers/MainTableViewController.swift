//
//  MainTableViewController.swift
//  CityLife
//
//  Created by KirRealDev 
//  Copyright © 2020 KirRealDev. All rights reserved.
//

import UIKit
import CoreLocation

class MainTableViewController: UITableViewController, SearchViewDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - IBActions
    @IBAction func cancelAction(_ segue: UIStoryboardSegue) {}
    @IBAction func tabSearchButton(_ sender: Any) {
        
        let searchVC = storyboard?.instantiateViewController(identifier: "searchViewController") as! SearchViewController
        searchVC.delegate = self
        searchVC.modalPresentationStyle = .overFullScreen
        present(searchVC, animated: true, completion: nil)
    }
    // MARK: - Managers
    let locationManager = CLLocationManager()
    
    // MARK: - Constants for TableView
    private enum ConstantsForTableView {
        
        static let defaultCountOfBasicRows = 4
    }
    
    // MARK: - Counter of current row for Quality Score Datas
    private var indexOfParameterQuality: Int = 0
    
    // MARK: - Data containers
    private var currLocation: CLLocationCoordinate2D? = nil
    private var qualityOfLifeDataContainer: QualityOfLifeData? = nil
    private var cityImageDataСontainer: CityImageData? = nil
    private var currCityInfo: CityInfoByCurrentLocation? = nil
    private var basicInfoDataContainer: BasicInfoData? = nil

    // MARK: - Load all Information about City
    func loadAllInformationAboutCity() {
        
        let service = NetworkService()
    
        service.loadBasicInfoByURL(onComplete: { [weak self] (cityInfo) in
            self?.basicInfoDataContainer = cityInfo
            NetworkVariable.currCityButtonName = self?.basicInfoDataContainer?.full_name ?? "data loading error"
            NetworkVariable.currCityShortName = self?.basicInfoDataContainer?.name ?? "data loading error"
            NetworkVariable.currCityPopulation = self?.basicInfoDataContainer?.population ?? 0
            NetworkVariable.currCityTimezone = self?.basicInfoDataContainer?._links.timezone.name ?? "data loading error"
            NetworkVariable.currUrbanAreaURL = self?.basicInfoDataContainer?._links.urban_area?.href ?? " "
            self?.navigationItem.title = NetworkVariable.currCityButtonName
            self?.loadImageData()
            self?.loadQualityOfLifeData()
            self?.mainTableView.reloadData()
        })
        { (error) in
            NSLog(error.localizedDescription)
        }
    }
    // MARK: - Load Image data
    func loadImageData() {
        
        let serviceImage = NetworkService()
           serviceImage.loadImageByURL(onComplete: { [weak self] (image) in
                self?.cityImageDataСontainer = image
                self?.mainTableView.reloadData() }) { (error) in
                NSLog(error.localizedDescription)
            }
    }
    // MARK: - Load Quality data
    private func loadQualityOfLifeData() {
        
        let serviceCity = NetworkService()
        serviceCity.loadQualityScoreByURL(onComplete: { [weak self] (city) in
            self?.qualityOfLifeDataContainer = city
            self?.mainTableView.reloadData()}) { (error) in
            NSLog(error.localizedDescription)
            }
    }
    // MARK: - Load Data by Location
    private func loadDataByLocation() {
        
        let currLat: Double = currLocation?.latitude ?? 55.755786
        let currLong: Double = currLocation?.longitude ?? 37.617633
        
        let service = NetworkService()
        service.loadInfoCityByCurrentLocation(lat: currLat, long: currLong, onComplete: { [weak self] (cityInfo) in
            self?.currCityInfo = cityInfo
            NetworkVariable.currCityButtonName = self?.currCityInfo?.embedded.locationNearestCities[0].links.locationNearestCity.name ?? "Moscow"
            NetworkVariable.currCityURL = self?.currCityInfo?.embedded.locationNearestCities[0].links.locationNearestCity.href ?? "https://api.teleport.org/api/cities/geonameid:524901/"
            self?.loadAllInformationAboutCity() }) {(error) in
                NSLog(error.localizedDescription)
            }
    }
    // MARK: - Get Current location
    private func getCurrentLocation() {
        
        // Ask for authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground.
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
    }
    // MARK: - did Finish Network Updates (delegate method)
    func didFinishNetworkUpdates() {
        
        self.locationManager.stopUpdatingLocation()
        loadAllInformationAboutCity()
    }
    // MARK: - view Did Load
    override func viewDidLoad() {
        
        loadDataByLocation()
        super.viewDidLoad()
    }
    // MARK: - view Did Appear
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
    }

    // MARK: - override tableView functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (qualityOfLifeDataContainer?.categories.count ?? 0) + ConstantsForTableView.defaultCountOfBasicRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as? ImageViewCell else {
                return UITableViewCell()
            }
            if (cityImageDataСontainer?.results.count == 0) {
                cell.customImageView.loadImageForCustomImageView(by: NetworkConstant.errorLoadImageURL)
                
                return cell
            }

            let model = cityImageDataСontainer?.results[indexPath.row] ?? nil
            cell.customImageView.loadImageForCustomImageView(by: model?.urls.regular ?? NetworkConstant.errorLoadImageURL)
            
                return cell
        }
        else if (indexPath.row == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleInfoCell", for: indexPath) as! TitleInfoViewCell
            cell.titleInfoLabel.text = "BASIC CITY INFO"
            
            return cell
        }
        else if (indexPath.row == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basicInfoCell", for: indexPath) as! BasicInfoViewCell
            cell.firstBasicParameterLabel.text = "Time zone"
            cell.firstBasicParameterValueLabel.text = NetworkVariable.currCityTimezone
            cell.secondBasicParameterLabel.text = "Population"
            cell.secondBasicParameterValueLabel.text = String(NetworkVariable.currCityPopulation)
            
            return cell
        }
        else if (indexPath.row == 3) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleInfoCell", for: indexPath) as! TitleInfoViewCell
            cell.titleInfoLabel.text = "LIFE QUALITY SCORE"
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "qualityScoreCell", for: indexPath) as! QualityScoreViewCell
            indexOfParameterQuality = indexPath.row - ConstantsForTableView.defaultCountOfBasicRows
            if (indexOfParameterQuality < qualityOfLifeDataContainer?.categories.count ?? 0) {
                cell.parameterOfQualityLabel.text = qualityOfLifeDataContainer?.categories[indexOfParameterQuality].name ?? "error writing data"
                cell.scoreLabel.text = String(format: "%.2f",qualityOfLifeDataContainer?.categories[indexOfParameterQuality].score_out_of_10 ?? 0)
                cell.scoreProgressView.setProgress((qualityOfLifeDataContainer?.categories[indexOfParameterQuality].score_out_of_10 ?? 0) / 10, animated: false)
                cell.scoreProgressView.progressTintColor  = UIColor(hex: qualityOfLifeDataContainer?.categories[indexOfParameterQuality].color ?? "#1965ad")
            }
            
            return cell
        }
    }

}

extension MainTableViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currLocation = locValue
        print("HEEELLLO!")
        print(currLocation?.latitude ?? 7.0)
        print(currLocation?.longitude ?? 7.0)
        loadDataByLocation()
        self.mainTableView.reloadData()
    }
}
