//
//  NetworkService.swift
//  CityLife
//
//  Created by KirRealDev
//  Copyright © 2020 KirRealDev. All rights reserved.
//

import Foundation

enum ServerError: Error {
    
    case noDataProvided
    case failedToDecode
}

class NetworkService {
    
    // MARK: - Load Image by URL
    func loadImageByURL(onComplete: @escaping (CityImageData) -> Void, onError: @escaping (Error) -> Void) {
        
        let currCityName =  NetworkVariable.currCityButtonName
            .components(separatedBy:" ")
        .filter { !$0.isEmpty }
            .joined(separator:"-")
        
        let urlString = NetworkConstant.baseURLImage + "/search/photos?page=1&per_page=1&query=" + currCityName + "&client_id=" + NetworkConstant.accessKeyForPhoto
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                onError(error)
                return
            }
            guard let  data = data else {
                onError(ServerError.noDataProvided)
                return
            }
            guard let image = try? JSONDecoder().decode(CityImageData.self, from: data) else {
                NSLog("could not decode")
                onError(ServerError.failedToDecode)
                return
            }
            DispatchQueue.main.async {
                onComplete(image)
            }
        }
        task.resume()
    }
    
    // MARK: - Load Quality Data by URL
    func loadQualityScoreByURL(onComplete: @escaping (QualityOfLifeData) -> Void, onError: @escaping (Error) -> Void) {

        let urlString = NetworkVariable.currUrbanAreaURL + "scores/"
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                onError(error)
                return
            }
            guard let  data = data else {
                onError(ServerError.noDataProvided)
                return
            }
            guard let qualityScore = try? JSONDecoder().decode(QualityOfLifeData.self, from: data) else {
                NSLog("could not decode")
                onError(ServerError.failedToDecode)
                return
            }
            DispatchQueue.main.async {
                onComplete(qualityScore)
            }
        }
        task.resume()
    }
    
    // MARK: - load Cities by Current Query
    func loadCitiesByCurrentQuery(query: String, onComplete: @escaping (CitySearchData) -> Void, onError: @escaping (Error) -> Void) {

        let urlString = NetworkConstant.baseURLForSearchCity + query

        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                onError(error)
                return
            }
            guard let  data = data else {
                onError(ServerError.noDataProvided)
                return
            }
            guard let searchResults = try? JSONDecoder().decode(CitySearchData.self, from: data) else {
                NSLog("could not decode")
                onError(ServerError.failedToDecode)
                return
            }
            DispatchQueue.main.async {
                onComplete(searchResults)
            }
        }
        task.resume()
    }
    
    // MARK: - Load Basic Info by URL
    func loadBasicInfoByURL(onComplete: @escaping (BasicInfoData) -> Void, onError: @escaping (Error) -> Void) {

        let urlString = NetworkVariable.currCityURL
        
        guard let url = URL(string: urlString) else { return }

           let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
               if let error = error {
                   onError(error)
                   return
               }
               guard let  data = data else {
                   onError(ServerError.noDataProvided)
                   return
               }
               guard let basicInfo = try? JSONDecoder().decode(BasicInfoData.self, from: data) else {
                   NSLog("could not decode")
                   onError(ServerError.failedToDecode)
                   return
               }
               DispatchQueue.main.async {
                   onComplete(basicInfo)
               }
           }
           task.resume()
       }
    
    func loadInfoCityByCurrentLocation(lat: Double, long: Double, onComplete: @escaping (CityInfoByCurrentLocation) -> Void, onError: @escaping (Error) -> Void) {
        
        let urlString = "https://api.teleport.org/api/locations/\(lat),\(long)/"
    
        guard let url = URL(string: urlString) else { return }

           let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
               if let error = error {
                   onError(error)
                   return
               }
               guard let  data = data else {
                   onError(ServerError.noDataProvided)
                   return
               }
               guard let infoByCurrLocation = try? JSONDecoder().decode(CityInfoByCurrentLocation.self, from: data) else {
                   NSLog("could not decode")
                   onError(ServerError.failedToDecode)
                   return
               }
               DispatchQueue.main.async {
                   onComplete(infoByCurrLocation)
               }
           }
           task.resume()
       }

}
