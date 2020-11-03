//
//  QualityOfLifeData.swift
//  CityLife
//
//  Created by KirRealDev 
//  Copyright © 2020 KirRealDev. All rights reserved.
//

import Foundation

struct QualityOfLifeData: Decodable {
    let categories: [CityData]
    let teleport_city_score: Float
}

struct CityData: Decodable {
    let color: String
    let name: String
    let score_out_of_10: Float
}
