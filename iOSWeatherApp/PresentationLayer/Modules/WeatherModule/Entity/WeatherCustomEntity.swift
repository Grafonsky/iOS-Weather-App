//
//  WeatherCustomEntity.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 08.01.2022.
//

import Foundation

struct WeatherCustomEntity: Codable {
    var city: String
    var currentTemp: String
    var minTemp: String
    var maxTemp: String
    var alert: [Alerts]
    var desc: String
    var feelsLike: String
    var humidity: String
    var windSpeed: String
    var sunrise: String
    var sunset: String
    var hourlyForecast: [Hourly]
    var dailyForecast: [Daily]
    var icon: String
}
