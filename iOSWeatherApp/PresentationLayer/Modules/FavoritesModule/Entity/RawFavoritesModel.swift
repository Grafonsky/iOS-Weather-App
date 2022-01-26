//
//  RawFavoritesModel.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 26.01.2022.
//

import Foundation

struct RawFavoritesModel: Codable {
    var name: String
    var country: String
    var coord: Coord
}

struct Coord: Codable {
    var lat: Double
    var lon: Double
}
