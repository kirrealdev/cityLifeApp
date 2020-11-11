//
//  NetworkParameters.swift
//  CityLife
//
//  Created by KirRealDev
//  Copyright © 2020 KirRealDev. All rights reserved.
//

import Foundation

enum NetworkConstant {
    
    static let accessKeyForPhoto = "C7So1asmp_10sJfWJJkxMkeeH3aLiIzG-mClpZxHj5k"
    static let baseURLImage = "https://api.unsplash.com"
    static let baseURLCity = "https://api.teleport.org/api/urban_areas/slug:"
    static let baseURLForSearchCity = "https://api.teleport.org/api/cities/?search="
    static let errorLoadImageURL = "https://unsplash.com/a/img/empty-states/photos.png" 
}

enum NetworkVariable {
    
    static var currCityURL = "https://api.teleport.org/api/cities/geonameid:524901/"
    static var currUrbanAreaURL = "https://api.teleport.org/api/urban_areas/slug:moscow/"
    static var currCityShortName = "Moscow-Moscow-Russia"
    static var currCityButtonName = "Moscow, Moscow, Russia"
    static var currCityTimezone = "Europe/Moscow"
    static var currCityPopulation: Int64 = 10381222
}
