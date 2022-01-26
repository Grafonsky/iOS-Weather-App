//
//  CustomFavoritesModel.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 26.01.2022.
//

import Foundation

struct CustomFavoritesModel: Codable {
    var name: String
    var country: String
    var lat: Double
    var lon: Double
}
