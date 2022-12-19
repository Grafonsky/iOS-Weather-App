//
//  WeatherData.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 29.10.2022.
//

import Foundation

struct WeatherData {
    let city: String
    let weatherModel: WeatherModel
}

extension WeatherData {
    
    static var mock: WeatherData {
        .init(
            city: "Johannesburg",
            weatherModel: .init(
                timeOffset: -14400,
                lat: 22,
                lon: 55,
                current: .init(
                    temp: 294.69,
                    windSpeed: 2.68,
                    humidity: 57,
                    weather: [.init(
                        description: "broken clouds",
                        icon: "04d")],
                    sunrise: 1667013640,
                    sunset: 1667060533,
                    feelsLike: 294.39),
                hourly: [],
                daily: [],
                alerts: []))
    }
}
