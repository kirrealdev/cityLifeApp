//
//  CitySearchData.swift
//  CityLife
//
//  Created by KirRealDev 
//  Copyright © 2020 KirRealDev. All rights reserved.
//

import Foundation

struct CitySearchData: Decodable {
    
    let embedded: EmbeddedData
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        
        case embedded = "_embedded"
        case count
    }
}

struct EmbeddedData: Decodable {
    
    let searchResults: [SearchResultData]
    
    enum CodingKeys: String, CodingKey {
        
        case searchResults = "city:search-results"
    }
}

struct SearchResultData: Decodable {
    
    let _links: LinksData
    let matching_full_name: String
}

struct LinksData: Decodable {
    
    let item: ItemData
    
    enum CodingKeys: String, CodingKey {
        
        case item = "city:item"
    }
}

struct ItemData: Decodable {
    
    let href: String
}
