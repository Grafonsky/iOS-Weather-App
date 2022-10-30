//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 29.10.2022.
//

import Foundation
import Combine

final class WeatherViewModel: ObservableObject {
    
    typealias HourlyForecast = (icon: String, date: String, temp: String)
    typealias DailyForecast = (icon: String, date: String, minTemp: String, maxTemp: String)
    
    private(set) var bag: Set<AnyCancellable> = .init()
    
    @Published private(set) var cityName: String?
    @Published private(set) var temp: String?
    @Published private(set) var windSpeed: String?
    @Published private(set) var humidity: String?
    @Published private(set) var weatherDescription: String?
    @Published private(set) var icon: String?
    @Published private(set) var sunrise: String?
    @Published private(set) var sunset: String?
    @Published private(set) var feelsLike: String?
    @Published private(set) var hourlyForecast: [HourlyForecast] = []
    @Published private(set) var dailyForecast: [DailyForecast] = []
    
    private var currentCityStore: AnyCancellable?
    
    private let locationService: LocationService
    private let weatherService: WeatherService
    
    init() {
        self.locationService = .init()
        self.weatherService = .init(locationService: self.locationService)
        
        LocationService._currentCity
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.updateData()
            })
            .store(in: &bag)
    }
}

private extension WeatherViewModel {
    
    func updateData() {
        Task {
            let weather = await weatherService.getCurrentTemp()
            switch weather {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    self?.updateUI(data: data)
                }
            case .failure(let error):
                break
            }
        }
    }
    
    func updateUI(data: WeatherData) {
        self.cityName = data.city
        self.temp = "\(Int(data.weatherModel.current.temp))°C"
        self.windSpeed = "\(data.weatherModel.current.windSpeed)\nkm/h"
        self.humidity = "\(data.weatherModel.current.humidity)%"
        self.weatherDescription = data.weatherModel.current.weather.first?.description
        self.icon = data.weatherModel.current.weather.first?.icon
        self.sunrise = DateFormatterService.shared.dateToString(
            time: data.weatherModel.current.sunrise,
            timezoneOffset: data.weatherModel.timeOffset,
            dateType: .sunMove)
        self.sunset = DateFormatterService.shared.dateToString(
            time: data.weatherModel.current.sunset,
            timezoneOffset: data.weatherModel.timeOffset,
            dateType: .sunMove)
        self.feelsLike = "\(data.weatherModel.current.feelsLike)°C"

        data.weatherModel.hourly.forEach { hourly in
            let icon = hourly.weather.first?.icon ?? ""
            let date = DateFormatterService.shared.dateToString(
                time: hourly.date,
                timezoneOffset: data.weatherModel.timeOffset,
                dateType: .hour)
            let currentHour = DateFormatterService.shared.dateToString(
                time: Int(Date().timeIntervalSince1970),
                timezoneOffset: data.weatherModel.timeOffset,
                dateType: .hour)
            let temp = "\(hourly.temp)°C"
            let item = (
                icon: icon,
                date: date == currentHour ? "Now" : date,
                temp: temp)
            self.hourlyForecast.append(item)
        }
        
        data.weatherModel.daily.forEach { daily in
            let icon = daily.weather.first?.icon ?? ""
            let date = DateFormatterService.shared.dateToString(
                time: daily.date,
                timezoneOffset: data.weatherModel.timeOffset,
                dateType: .weekDay)
            let currentDay = DateFormatterService.shared.dateToString(
                time: Int(Date().timeIntervalSince1970),
                timezoneOffset: data.weatherModel.timeOffset,
                dateType: .weekDay)
            let mintemp = "\(daily.temp.min)°C"
            let maxTemp = "\(daily.temp.max)°C"
            let item = (
                icon: icon,
                date: date == currentDay ? "Today" : date,
                minTemp: mintemp,
                maxTemp: maxTemp)
            self.dailyForecast.append(item)
        }
    }
}
