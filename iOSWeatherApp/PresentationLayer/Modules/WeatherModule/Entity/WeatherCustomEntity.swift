//
//  WeatherCustomEntity.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 08.01.2022.
//

import Foundation

struct WeatherCustomEntity: Codable {
    var city: String
    var lat: Double
    var lon: Double
    var currentTemp: Double
    var minTemp: Double
    var maxTemp: Double
    var alert: [Alerts]
    var desc: String
    var feelsLike: Double
    var humidity: Int
    var windSpeed: Double
    var sunrise: Int
    var sunset: Int
    var hourlyForecast: [Hourly]
    var dailyForecast: [Daily]
    var icon: String
}
