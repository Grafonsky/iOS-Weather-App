//
//  WeatherModel.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 29.10.2022.
//

import Foundation

// MARK: - WeatherModel

struct WeatherModel: Decodable {
    let timeOffset: Int
    let current: CurrentWeather
    let hourly: [HourlyWeather]
    let daily: [DailyWeather]
    let alerts: [Alerts]?
    
    enum CodingKeys: String, CodingKey {
        case current, hourly, daily, alerts
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

// MARK: - Alerts

extension WeatherModel {
    
    struct Alerts: Decodable {
        let event: String
        let description: String
        let start: Int
        let end: Int
    }
    
}
