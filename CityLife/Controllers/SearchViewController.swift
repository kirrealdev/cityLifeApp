//
//  SearchViewController.swift
//  CityLife
//
//  Created by KirRealDev 
//  Copyright © 2020 KirRealDev. All rights reserved.
//
protocol SearchViewDelegate: class {
    
    func didFinishNetworkUpdates()
}

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - delegate variable
    weak var delegate: SearchViewDelegate?
    
    // MARK: - Data containers
    private var searchResultDataArray = [SearchResultData]()
    private var basicInfoDataContainer: BasicInfoData? = nil
        
    // MARK: - Load data
    func loadCitiesNames(query: String) {
        
        let service = NetworkService()
        service.loadCitiesByCurrentQuery(query: query, onComplete: { [weak self] (cities) in
            self?.searchResultDataArray = cities.embedded.searchResults
            self?.searchTableView.reloadData() }) {(error) in
                NSLog(error.localizedDescription)
            }
    }
    
    func loadBasicInfoData() {
        
        let service = NetworkService()
    
        service.loadBasicInfoByURL(onComplete: { [weak self] (cityInfo) in
            self?.basicInfoDataContainer = cityInfo
            NetworkVariable.currCityButtonName = self?.basicInfoDataContainer?.full_name ?? "data loading error"
            NetworkVariable.currCityShortName = self?.basicInfoDataContainer?.name ?? "data loading error"
            NetworkVariable.currCityPopulation = self?.basicInfoDataContainer?.population ?? 0
            NetworkVariable.currCityTimezone = self?.basicInfoDataContainer?._links.timezone.name ?? "data loading error"
            NetworkVariable.currUrbanAreaURL = self?.basicInfoDataContainer?._links.urban_area?.href ?? " "
            self?.delegate?.didFinishNetworkUpdates()
        })
        { (error) in
            NSLog(error.localizedDescription)
        }
    }
    
    // MARK: - viev Did Load
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }

}

// MARK: - extensions
extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResultDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath)
        cell.textLabel?.text = searchResultDataArray[indexPath.row].matching_full_name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NetworkVariable.currCityURL = searchResultDataArray[indexPath.row]._links.item.href
        loadBasicInfoData()
        dismiss(animated: true, completion: nil)
    }

}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        loadCitiesNames(query: searchText)
    }

}
