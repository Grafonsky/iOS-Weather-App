//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 29.10.2022.
//

import SwiftUI
import Combine

final class WeatherViewModel: ObservableObject {
    
    typealias HourlyForecast = (icon: String, date: String, temp: String)
    typealias DailyForecast = (icon: String, date: String, minTemp: CGFloat, maxTemp: CGFloat, isCurrentDay: Bool)
    typealias Alert = (event: String, description: String, start: Int, end: Int)
    
    private(set) var bag: Set<AnyCancellable> = .init()
    
    @Published private(set) var cityName: String?
    @Published private(set) var temp: String?
    @Published private(set) var weatherDescription: String?
    @Published private(set) var icon: String?
    
    @Published var dailyForecast: [DailyForecast] = []
    @Published var hourlyForecast: [HourlyForecast] = []
    @Published var alert: String?
    @Published var feelsLike: String?
    @Published var humidity: String?
    @Published var windSpeed: String?
    @Published var topBackgroundColor: String = ""
    @Published var bottomBackgroundColor: String = ""
    @Published var sunrise: String?
    @Published var sunset: String?
    @Published var minTemp: String?
    @Published var maxTemp: String?
    
    var minWeekTemp: CGFloat = 999
    var maxWeekTemp: CGFloat = -999
    var currentTemp: CGFloat = 999
    var spriteKitNodes: [SpriteKitNode] = []
    var isFeelsLikeCoolerTemp: Bool = false
    var isAMtime: Bool = false
    
    private var currentCityStore: AnyCancellable?
    
    private let locationService: LocationService
    private let weatherService: WeatherService
    private let iconsModel: WeatherIconsModel
    
    init() {
        self.locationService = .init()
        self.weatherService = .init(locationService: self.locationService)
        self.iconsModel = .init()
        
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
        setupData(data: data)
        setupHourlyForecast(data: data)
        setupDailyForecast(data: data)
        setupAlerts(data: data)
        setupAdditionalWeatherInfo(data: data)
    }
    
    func setupData(data: WeatherData) {
        self.alert = nil
        self.hourlyForecast = []
        self.dailyForecast = []
        
        self.cityName = data.city
        self.temp = "\(Int(data.weatherModel.current.temp))°"
        self.minTemp = "\(Int(data.weatherModel.daily.first?.temp.min ?? 0))"
        self.maxTemp = "\(Int(data.weatherModel.daily.first?.temp.max ?? 0))"
        self.currentTemp = data.weatherModel.current.temp
        self.windSpeed = "\(data.weatherModel.current.windSpeed) km/h"
        self.humidity = "\(Int(data.weatherModel.current.humidity))%"
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
        self.feelsLike = "\(Int(data.weatherModel.current.feelsLike))°"
        
        self.topBackgroundColor = WeatherGradientModel().colors[icon ?? ""]?[0] ?? ""
        self.bottomBackgroundColor = WeatherGradientModel().colors[icon ?? ""]?[1] ?? ""
        self.spriteKitNodes = SpriteKitNodes().nodes[icon ?? ""] ?? []
    }
    
    func setupHourlyForecast(data: WeatherData) {
        data.weatherModel.hourly.forEach { hourly in
            if self.hourlyForecast.count <= 23 {
                let icon = self.iconsModel.iconsDict[hourly.weather.first?.icon ?? ""] ?? ""
                let date = DateFormatterService.shared.dateToString(
                    time: hourly.date,
                    timezoneOffset: data.weatherModel.timeOffset,
                    dateType: .hour)
                let currentHour = DateFormatterService.shared.dateToString(
                    time: Int(Date().timeIntervalSince1970),
                    timezoneOffset: data.weatherModel.timeOffset,
                    dateType: .hour)
                let temp = "\(Int(hourly.temp))°"
                let item = (
                    icon: icon,
                    date: date == currentHour ? "now".localizable : date,
                    temp: temp)
                self.hourlyForecast.append(item)
            }
        }
    }
    
    func setupDailyForecast(data: WeatherData) {
        data.weatherModel.daily.forEach { daily in
            let icon = self.iconsModel.iconsDict[daily.weather.first?.icon ?? ""] ?? ""
            let date = DateFormatterService.shared.dateToString(
                time: daily.date,
                timezoneOffset: data.weatherModel.timeOffset,
                dateType: .weekDay)
            let currentDay = DateFormatterService.shared.dateToString(
                time: Int(Date().timeIntervalSince1970),
                timezoneOffset: data.weatherModel.timeOffset,
                dateType: .weekDay)
            let mintemp: CGFloat = daily.temp.min
            let maxTemp: CGFloat = daily.temp.max
            
            if minWeekTemp > mintemp {
                minWeekTemp = mintemp
            }
            
            if maxWeekTemp < maxTemp {
                maxWeekTemp = maxTemp
            }
            
            let isCurrentDay = date == currentDay ? true : false
            
            let item = (
                icon: icon,
                date: isCurrentDay ? "today".localizable : date.capitalizingFirstLetter(),
                minTemp: mintemp,
                maxTemp: maxTemp,
                isCurrentDay: isCurrentDay)
            
            if self.dailyForecast.count < 7 {
                self.dailyForecast.append(item)
            }
        }
    }
    
    func setupAlerts(data: WeatherData) {
        if data.weatherModel.alerts != nil {
            let alertEvent = data.weatherModel.alerts?.last?.event ?? ""
            let alertDescription = data.weatherModel.alerts?.last?.description ?? ""
            let alertStartDate = DateFormatterService.shared.dateToString(
                time: data.weatherModel.alerts?.last?.start ?? 0,
                timezoneOffset: data.weatherModel.timeOffset,
                dateType: .sunMove)
            let alertEndDate = DateFormatterService.shared.dateToString(
                time: data.weatherModel.alerts?.last?.end ?? 0,
                timezoneOffset: data.weatherModel.timeOffset,
                dateType: .sunMove)
            self.alert = String(format: NSLocalizedString(
                "alert", comment: ""),
                                alertEvent,
                                alertDescription,
                                alertStartDate,
                                alertEndDate)
        }
    }
    
    func setupAdditionalWeatherInfo(data: WeatherData) {
        setupFeelsLikeInfo(data: data)
        setupSunsetInfo(data: data)
    }
    
    func setupFeelsLikeInfo(data: WeatherData) {
        let actualTemp = Int(data.weatherModel.current.temp)
        let feelsLikeTemp = Int(data.weatherModel.current.feelsLike)
        self.isFeelsLikeCoolerTemp = actualTemp > feelsLikeTemp ? true : false
    }
    
    func setupSunsetInfo(data: WeatherData) {
        let currentEpochTime = Int(Date().timeIntervalSince1970 * 1000.0)
        let currentHour = DateFormatterService.shared.dateToString(
            time: currentEpochTime,
            timezoneOffset: data.weatherModel.timeOffset,
            dateType: .comparisonHours)
        isAMtime = Int(currentHour) ?? 0 < 12 ? true : false
    }
}
