//
//  WeatherModel.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 29.10.2022.
//

import Foundation

//// MARK: - WeatherIcon
//
//enum WeatherIcon {
//    enum IconType: String {
//        case day            = "d"
//        case night          = "n"
//    }
//
//    init(rawValue: String) {
//        let id: String = String(rawValue.prefix(2))
//        let iconType: IconType = .init(rawValue: String(rawValue.suffix(1))) ?? .day
//        self = .weather(id: id, icon: iconType)
//    }
//
//    case weather(id: String, icon: IconType)
//
//    var name: String {
//        switch self {
//        case .weather(let id, let icon):
//            return id + icon.rawValue
//        }
//    }
//}

// MARK: - WeatherModel

struct WeatherModel: Decodable {
    let timeOffset: Int
    let current: CurrentWeather
    let hourly: [HourlyWeather]
    let daily: [DailyWeather]
    
    enum CodingKeys: String, CodingKey {
        case current, hourly, daily
        case timeOffset = "timezone_offset"
    }
}

// MARK: - CurrentWeather

extension WeatherModel {
    
    struct CurrentWeather: Decodable {
        let temp: Double
        let windSpeed: Double
        let humidity: Double
        let weather: [Weather]
        let sunrise: Int
        let sunset: Int
        let feelsLike: Double
        
        enum CodingKeys: String, CodingKey {
            case temp, humidity, weather, sunrise, sunset
            case windSpeed = "wind_speed"
            case feelsLike = "feels_like"
        }
    }
    
    struct Weather: Decodable {
        public let description: String
        public let icon: String
    }
}

// MARK: - HourlyWeather

extension WeatherModel {
    
    public struct HourlyWeather: Decodable {
        let date: Int
        let temp: Double
        let weather: [Weather]
        
        enum CodingKeys: String, CodingKey {
            case temp, weather
            case date = "dt"
        }
    }
}

// MARK: - DailyWeather

extension WeatherModel {
    
    struct DailyWeather: Decodable {
        let date: Int
        let temp: Temp
        let weather: [Weather]
        
        enum CodingKeys: String, CodingKey {
            case temp, weather
            case date = "dt"
        }
    }
    
    struct Temp: Decodable {
        let min: Double
        let max: Double
    }
}
