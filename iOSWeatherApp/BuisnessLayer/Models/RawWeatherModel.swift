//
//  RawWeatherModel.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 08.01.2022.
//

struct RawWeatherModel: Codable {
    var lat: Double
    var lon: Double
    var current: Current
    var daily: [Daily]
}

struct Current: Codable {
    var temp: Double
    var feels_like: Double
    var humidity: Double
    var wind_speed: Double
    var weather: [Weather]
}

struct Weather: Codable {
    var main: String
    var description: String
}

struct Daily: Codable {
    var dt: Int
    var temp: Temp
}

struct Temp: Codable {
    var day: Double
    var night: Double
}
