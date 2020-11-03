//
//  MainTableViewController.swift
//  CityLife
//
//  Created by KirRealDev 
//  Copyright © 2020 KirRealDev. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    @IBOutlet weak var mainTableView: UITableView!
    @IBAction func cancelAction(_ segue: UIStoryboardSegue) {}
    
    private enum Constants {
        static let defaultCountOfBasicRows = 4 // переименовать
    }
    
    var indexOfParameterQuality: Int = 0
    var dataOfQuality: QualityOfLifeData? = nil

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
        loadQualityDataForCities()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataOfQuality?.categories.count ?? 0) + Constants.defaultCountOfBasicRows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageViewCell
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
            cell.secondBasicParameterValueLabel.text = NetworkVariable.currCityPopulation
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
                print("написал в label", dataOfQuality?.categories[indexOfParameterQuality].name ?? "error writing data")
            }
            return cell
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
