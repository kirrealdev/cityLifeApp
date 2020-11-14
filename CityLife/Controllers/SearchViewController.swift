//
//  SearchViewController.swift
//  CityLife
//
//  Created by KirRealDev 
//  Copyright © 2020 KirRealDev. All rights reserved.
//
protocol SearchViewDelegate: class {
    
    func didFinishUpdates()
}

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    weak var delegate: SearchViewDelegate?
    
    var citiesArray = [SearchResultData]()
    var basicInfoOfCity: BasicInfoData? = nil
    
    
    // MARK: - Loading data
    func loadCitiesByCurrentQuery(query: String) {
        
        let service = NetworkService()
        service.searchByCity(query: query, onComplete: { [weak self] (cities) in
            self?.citiesArray = cities.embedded.searchResults
            self?.searchTableView.reloadData() }) {(error) in
                NSLog(error.localizedDescription)
            }
    }
    
    func loadBasicDataOfCity() {
        
        let service = NetworkService()
    
        service.loadBasicInfo(onComplete: { [weak self] (cityInfo) in
            self?.basicInfoOfCity = cityInfo
            NetworkVariable.currCityButtonName = self?.basicInfoOfCity?.full_name ?? "data loading error"
            NetworkVariable.currCityShortName = self?.basicInfoOfCity?.name ?? "data loading error"
            NetworkVariable.currCityPopulation = self?.basicInfoOfCity?.population ?? 0
            NetworkVariable.currCityTimezone = self?.basicInfoOfCity?._links.timezone.name ?? "data loading error"
            NetworkVariable.currUrbanAreaURL = self?.basicInfoOfCity?._links.urban_area?.href ?? " "
            self?.delegate?.didFinishUpdates()
        })
        { (error) in
            NSLog(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }

}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return citiesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath)
        cell.textLabel?.text = citiesArray[indexPath.row].matching_full_name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NetworkVariable.currCityURL = citiesArray[indexPath.row]._links.item.href
        loadBasicDataOfCity()
        dismiss(animated: true, completion: nil)
    }

}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        loadCitiesByCurrentQuery(query: searchText)
    }

}
