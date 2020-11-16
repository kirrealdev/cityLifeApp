//
//  MainTableViewController.swift
//  CityLife
//
//  Created by KirRealDev 
//  Copyright © 2020 KirRealDev. All rights reserved.
//

import UIKit

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
    
    // MARK: - Constants for TableView
    private enum ConstantsForTableView {
        
        static let defaultCountOfBasicRows = 4
    }
    
    // MARK: - Counter of current row for Quality Score Datas
    private var indexOfParameterQuality: Int = 0
    
    // MARK: - Data containers
    private var qualityOfLifeDataContainer: QualityOfLifeData? = nil
    private var cityImageDataСontainer: CityImageData? = nil

    // MARK: - Load data
    func loadImageData() {
        
        let serviceImage = NetworkService()
           serviceImage.loadImageByURL(onComplete: { [weak self] (image) in
                self?.cityImageDataСontainer = image
                self?.mainTableView.reloadData() }) { (error) in
                NSLog(error.localizedDescription)
            }
    }
    
    private func loadQualityOfLifeData() {
        
        let serviceCity = NetworkService()
        serviceCity.loadQualityScoreByURL(onComplete: { [weak self] (city) in
            self?.qualityOfLifeDataContainer = city
            self?.mainTableView.reloadData()}) { (error) in
            NSLog(error.localizedDescription)
            }
    }
    
    // MARK: - view Did Load
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadImageData()
        loadQualityOfLifeData()
        self.navigationItem.title = NetworkVariable.currCityButtonName
    }
    
    // MARK: - did Finish Updates
    func didFinishUpdates() {
        
        loadImageData()
        loadQualityOfLifeData()
        self.navigationItem.title = NetworkVariable.currCityButtonName
        self.mainTableView.reloadData()
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
