//
//  CityImageData.swift
//  CityLife
//
//  Created by KirRealDev 
//  Copyright © 2020 KirRealDev. All rights reserved.
//
import Foundation

struct CityImageData: Decodable {
    
    let results: [Results]
}

struct Results: Decodable {
    
    let id: String
    let urls: UrlsData
}

struct UrlsData: Decodable {
    
    let regular: String
    let small: String
}
