//
//  WeatherEntity.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 08.01.2022.
//

import Foundation

struct WeatherRawEntity: Codable {
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
//    var alerts: [Alerts]
}

struct Current: Codable {
    let temp: Double
    var feels_like: Double
    let humidity: Double
    let wind_speed: Double
    let sunrise: Double
    let sunset: Double
    let weather: [Weather]
}

struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}

struct Hourly: Codable {
    let dt: Double
    let temp: Double
    let weather: [WeatherHourlyIcons]
}

struct WeatherHourlyIcons: Codable {
    let icon: String
}

struct Daily: Codable {
    let dt: Double
    let temp: Temp
    let weather: [WeatherDailyIcons]
}

struct Temp: Codable {
    let min: Double
    let max: Double
}

struct WeatherDailyIcons: Codable {
    let icon: String
}

struct Alerts: Codable {
    var event: String = ""
    var start: Int = 0
    var end: Int = 0
    var description: String = ""
}
