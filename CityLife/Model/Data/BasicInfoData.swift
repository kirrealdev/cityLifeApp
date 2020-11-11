//
//  BasicInfoData.swift
//  CityLife
//
//  Created by KirRealDev 
//  Copyright © 2020 KirRealDev. All rights reserved.
//

import Foundation

struct BasicInfoData: Decodable {
    
    let _links: ExtendedBasicInfoData
    let full_name: String
    let name: String
    let population: Int64
}

struct ExtendedBasicInfoData: Decodable {
    
    let timezone: TimezoneData
    let urban_area: UrbanAreaData?
    
    enum CodingKeys: String, CodingKey {
        
        case timezone = "city:timezone"
        case urban_area = "city:urban_area"
    }

}

struct TimezoneData: Decodable {
    
    let name: String
}

struct UrbanAreaData: Decodable {
    
    let href: String
}
