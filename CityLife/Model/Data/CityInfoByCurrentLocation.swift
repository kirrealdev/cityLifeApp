//
//  CityInfoByCurrentLocation.swift
//  CityLife
//
//  Created by KirRealDev on 12.03.2021.
//  Copyright © 2021 KirRealDev. All rights reserved.
//

import Foundation

// MARK: - CityInfoByCurrentLocation
struct CityInfoByCurrentLocation: Codable {
    let embedded: Embedded
    let links: CityInfoByCurrentLocationLinks
    let coordinates: Coordinates

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
        case links = "_links"
        case coordinates
    }
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let geohash: String
    let latlon: Latlon
}

// MARK: - Latlon
struct Latlon: Codable {
    let latitude, longitude: Double
}

// MARK: - Embedded
struct Embedded: Codable {
    let locationNearestCities: [LocationNearestCity]
    let locationNearestUrbanAreas: [LocationNearestUrbanArea]

    enum CodingKeys: String, CodingKey {
        case locationNearestCities = "location:nearest-cities"
        case locationNearestUrbanAreas = "location:nearest-urban-areas"
    }
}

// MARK: - LocationNearestCity
struct LocationNearestCity: Codable {
    let links: LocationNearestCityLinks
    let distanceKM: Double

    enum CodingKeys: String, CodingKey {
        case links = "_links"
        case distanceKM = "distance_km"
    }
}

// MARK: - LocationNearestCityLinks
struct LocationNearestCityLinks: Codable {
    let locationNearestCity: LocationNearest

    enum CodingKeys: String, CodingKey {
        case locationNearestCity = "location:nearest-city"
    }
}

// MARK: - LocationNearest
struct LocationNearest: Codable {
    let href: String
    let name: String
}

// MARK: - LocationNearestUrbanArea
struct LocationNearestUrbanArea: Codable {
    let links: LocationNearestUrbanAreaLinks
    let distanceKM: Int

    enum CodingKeys: String, CodingKey {
        case links = "_links"
        case distanceKM = "distance_km"
    }
}

// MARK: - LocationNearestUrbanAreaLinks
struct LocationNearestUrbanAreaLinks: Codable {
    let locationNearestUrbanArea: LocationNearest

    enum CodingKeys: String, CodingKey {
        case locationNearestUrbanArea = "location:nearest-urban-area"
    }
}

// MARK: - CityInfoByCurrentLocationLinks
struct CityInfoByCurrentLocationLinks: Codable {
    let curies: [Cury]
    let linksSelf: SelfClass

    enum CodingKeys: String, CodingKey {
        case curies
        case linksSelf = "self"
    }
}

// MARK: - Cury
struct Cury: Codable {
    let href, name: String
    let templated: Bool
}

// MARK: - SelfClass
struct SelfClass: Codable {
    let href: String
}
