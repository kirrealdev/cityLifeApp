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
    
    func loadImage(onComplete: @escaping (CityImageData) -> Void, onError: @escaping (Error) -> Void) {
        
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
            guard let photo = try? JSONDecoder().decode(CityImageData.self, from: data) else {
                print("could not decode")
                onError(ServerError.failedToDecode)
                return
            }
            DispatchQueue.main.async {
                onComplete(photo)
            }
            }
        task.resume()
    }
    
    func loadQualityScore(onComplete: @escaping (QualityOfLifeData) -> Void, onError: @escaping (Error) -> Void) {

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
            guard let qualityScoreData = try? JSONDecoder().decode(QualityOfLifeData.self, from: data) else {
                print("could not decode")
                onError(ServerError.failedToDecode)
                return
            }
            DispatchQueue.main.async {
                onComplete(qualityScoreData)
            }
        }
        task.resume()
    }

    func searchByCity(query: String, onComplete: @escaping (CitySearchData) -> Void, onError: @escaping (Error) -> Void) {

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
            guard let searchCity = try? JSONDecoder().decode(CitySearchData.self, from: data) else {
                print("could not decode")
                onError(ServerError.failedToDecode)
                return
            }

            DispatchQueue.main.async {
                onComplete(searchCity)
            }

        }
        task.resume()
    }

    func loadBasicInfo(onComplete: @escaping (BasicInfoData) -> Void, onError: @escaping (Error) -> Void) {

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
               guard let basicInfoOfCity = try? JSONDecoder().decode(BasicInfoData.self, from: data) else {
                   print("could not decode")
                   onError(ServerError.failedToDecode)
                   return
               }
               DispatchQueue.main.async {
                   onComplete(basicInfoOfCity)
               }
           }
           task.resume()
       }
}