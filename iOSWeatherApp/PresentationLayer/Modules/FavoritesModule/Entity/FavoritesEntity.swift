//
//  ChoosenCitiesEntity.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 26.01.2022.
//

import Foundation

struct FavoritesEntity: Codable {
    var locations: [LocationModel]
}

struct LocationModel: Codable {
    var cityName: String
    var lat: Double
    var lon: Double
    var subTitle: String
    var weatherDesc: String
    var temp: Double
    var minTemp: Double
    var maxTemp: Double
    var icon: String
}
