//
//  MainTableViewController.swift
//  CityLife
//
//  Created by KirRealDev 
//  Copyright © 2020 KirRealDev. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, SearchViewDelegate {

    @IBOutlet weak var mainTableView: UITableView!
    
    @IBAction func cancelAction(_ segue: UIStoryboardSegue) {}
    
    @IBAction func tabSearchButton(_ sender: Any) {
        let searchVC = storyboard?.instantiateViewController(identifier: "searchViewController") as! SearchViewController
        searchVC.delegate = self
        searchVC.modalPresentationStyle = .overFullScreen
        present(searchVC, animated: true, completion: nil)
    }
    
    private enum Constants {
        static let defaultCountOfBasicRows = 4 // переименовать
    }
    
    var indexOfParameterQuality: Int = 0
    var dataOfQuality: QualityOfLifeData? = nil
    var imageData: CityImageData? = nil
    
    func didFinishUpdates() {
        viewDidLoad()
    }
    
    func loadPhotoData() {
        let servicePhoto = NetworkService()
           servicePhoto.loadImage(onComplete: { [weak self] (photo) in
                self?.imageData = photo
                self?.mainTableView.reloadData() }) { (error) in
                print(error.localizedDescription)
                }
    }
    
    private func loadQualityDataForCities() {

    let serviceCity = NetworkService()
    serviceCity.loadQualityScore(onComplete: { [weak self] (city) in
            self?.dataOfQuality = city
            self?.mainTableView.reloadData()}) { (error) in
            print(error.localizedDescription)
            }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhotoData()
        loadQualityDataForCities()
        self.navigationItem.title = NetworkVariable.currCityButtonName
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataOfQuality?.categories.count ?? 0) + Constants.defaultCountOfBasicRows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as? ImageViewCell else {
                return UITableViewCell()
            }
            if (imageData?.results.count == 0) { cell.customImageView.loadImage(by: NetworkConstant.errorLoadImageURL)
                return cell
                }
            let model = imageData?.results[indexPath.row] ?? nil
            cell.customImageView.loadImage(by: model?.urls.regular ?? NetworkConstant.errorLoadImageURL)
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
            indexOfParameterQuality = indexPath.row - Constants.defaultCountOfBasicRows
            if (indexOfParameterQuality < dataOfQuality?.categories.count ?? 0) {
                cell.parameterOfQualityLabel.text = dataOfQuality?.categories[indexOfParameterQuality].name ?? "error writing data"
                cell.scoreLabel.text = String(format: "%.2f",dataOfQuality?.categories[indexOfParameterQuality].score_out_of_10 ?? 0)
                cell.scoreProgressView.setProgress((dataOfQuality?.categories[indexOfParameterQuality].score_out_of_10 ?? 0) / 10, animated: false) // подумать
                cell.scoreProgressView.progressTintColor = UIColor(hexString: dataOfQuality?.categories[indexOfParameterQuality].color ?? "#1965ad")
            
            }
            return cell
        }
    }

}
