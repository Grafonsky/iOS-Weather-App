//
//  CityData.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 20.12.22.
//

import Foundation

struct CityModel: Decodable {
    let geonames: [Geonames]
}

struct Geonames: Decodable {
    let adminName: String
    let countryName: String
    let name: String
    let countryCode: String
    let lat: String
    let lng: String
    
    enum CodingKeys: String, CodingKey {
        case countryName, name, countryCode, lat, lng
        case adminName = "adminName1"
    }
}
