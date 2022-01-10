//
//  CustomWeatherModel.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 08.01.2022.
//

import Foundation

class CustomWeatherModel: Codable {
    static var shared: CustomWeatherModel = CustomWeatherModel()
    var city: String = ""
    var temp: Double = 0
    var desc: String = ""
    var feelsLike: Double = 0
    var humidity: Double = 0
    var windSpeed: Double = 0
    var dailyForecast: [CustomDailyWeatherModel] = []
    
    private init() {}
    
    func setCity(city: String) {
        self.city = city
    }
    
    func setTemp(temp: Double) {
        self.temp = round(temp - 273.15)
    }
    
    func setDesc(desc: String) {
        self.desc = desc
    }
    
    func setFeelsLike(feelsLike: Double) {
        self.feelsLike = round(feelsLike - 273.15)
    }
    
    func setHumidity(humidity: Double) {
        self.humidity = humidity
    }
    
    func setWindSpeed(windSpeed: Double) {
        self.windSpeed = windSpeed
    }
    
    func setDailyForecast(dailyForecast: [CustomDailyWeatherModel]) {
        self.dailyForecast = dailyForecast
    }
}

class CustomDailyWeatherModel: Codable {
    var date: Int
    var dayTemp: Double
    var nightTemp: Double
    
    init(date: Int, dayTemp: Double, nightTemp: Double) {
        self.date = date
        self.dayTemp = round(dayTemp - 273.15)
        self.nightTemp = round(nightTemp - 273.15)
    }
}
