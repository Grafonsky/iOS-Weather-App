//
//  CustomCityDataModel.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 10.01.2022.
//

import Foundation

struct CustomCityDataModel: Codable {
    var name: String
    var country: String
    var lat: Double
    var lon: Double
}
