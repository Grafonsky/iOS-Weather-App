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
    var timeOffset: Int = 0
    
    private var currentCityStore: AnyCancellable?
    
    private let weatherService: WeatherService
    private let iconsModel: WeatherIconsModel
    
    init(locationService: LocationService) {
        self.weatherService = .init(locationService: locationService)
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
        loadDataFromCoreData()
        Task {
            let weather = await weatherService.getCurrentTemp()
            switch weather {
            case .success(_):
                loadDataFromCoreData()
            case .failure(let error):
                print("INSERT FAILURE ALERT")
                break
            }
        }
    }
    
    func loadDataFromCoreData() {
        DispatchQueue.main.async { [weak self] in
            guard let savedData = CoreDataService.shared.getAllCities().first
            else { return }
            self?.updateUI(data: savedData)
        }
    }
    
    func updateUI(data: City) {
        timeOffset = Int(data.weather?.timeOffset ?? 0)
        
        setupBackground(data: data)
        setupData(data: data)
        setupHourlyForecast(data: data)
        setupDailyForecast(data: data)
        setupAlerts(data: data)
        setupAdditionalWeatherInfo(data: data)
    }
    
    func setupBackground(data: City) {
        let icon = data.weather?.icon
        self.topBackgroundColor = WeatherGradientModel().colors[icon ?? ""]?[0] ?? ""
        self.bottomBackgroundColor = WeatherGradientModel().colors[icon ?? ""]?[1] ?? ""
        self.spriteKitNodes = SpriteKitNodes().nodes[icon ?? ""] ?? []
    }
    
    func setupData(data: City) {
        self.alert = nil
        self.hourlyForecast = []
        self.dailyForecast = []
        
        self.cityName = data.name
        self.temp = "\(Int(data.weather?.temp ?? 0.0))°"
        self.minTemp = "\(Int(data.weather?.minTemp ?? 0.0))"
        self.maxTemp = "\(Int(data.weather?.maxTemp ?? 0.0))"
        self.currentTemp = CGFloat(data.weather?.temp ?? 0.0)
        self.windSpeed = "\(data.weather?.windSpeed ?? 0.0) km/h"
        self.humidity = "\(Int(data.weather?.humidity ?? 0.0))%"
        self.weatherDescription = data.weather?.weatherDescription ?? ""
        self.icon = data.weather?.icon ?? ""
        self.sunrise = DateFormatterService.shared.dateToString(
            time: Int(data.weather?.sunrise ?? Int64(0.0)),
            timezoneOffset: Int(data.weather?.timeOffset ?? Int64(0.0)),
            dateType: .sunMove)
        self.sunset = DateFormatterService.shared.dateToString(
            time: Int(data.weather?.sunset ?? Int64(0.0)),
            timezoneOffset: Int(data.weather?.timeOffset ?? Int64(0.0)),
            dateType: .sunMove)
        self.feelsLike = "\(Int(data.weather?.feelsLike ?? 0.0))°"
    }
    
    func setupHourlyForecast(data: City) {
        var hourlyWeather = data.weather?.hourly?.allObjects as? [Hourly]
        hourlyWeather?.sort { $0.date < $1.date }
        hourlyWeather?.enumerated().forEach { hourly in
            let icon = self.iconsModel.iconsDict[hourly.element.icon ?? ""] ?? ""
            let date = DateFormatterService.shared.dateToString(
                time: Int(hourly.element.date),
                timezoneOffset: timeOffset,
                dateType: .hour)
            let currentHour = DateFormatterService.shared.dateToString(
                time: Int(Date().timeIntervalSince1970),
                timezoneOffset: timeOffset,
                dateType: .hour)
            let temp = "\(Int(hourly.element.temp))°"
            let item = (
                icon: icon,
                date: date == currentHour ? "now".localizable : date,
                temp: temp)
            if hourly.offset <= 23 {
                self.hourlyForecast.append(item)
            }
        }
    }
    
    func setupDailyForecast(data: City) {
        var dailyWeather = data.weather?.daily?.allObjects as? [Daily]
        dailyWeather?.sort { $0.date < $1.date }
        dailyWeather?.enumerated().forEach { daily in
            let icon = self.iconsModel.iconsDict[daily.element.icon ?? ""] ?? ""
            let date = DateFormatterService.shared.dateToString(
                time: Int(daily.element.date),
                timezoneOffset: timeOffset,
                dateType: .weekDay)
            let currentDay = DateFormatterService.shared.dateToString(
                time: Int(Date().timeIntervalSince1970),
                timezoneOffset: timeOffset,
                dateType: .weekDay)
            let mintemp: CGFloat = daily.element.minTemp
            let maxTemp: CGFloat = daily.element.maxTemp
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
    
    func setupAlerts(data: City) {
        if data.weather?.alert != nil {
            let alertEvent = data.alert?.event ?? ""
            let alertDescription = data.alert?.alertDescription ?? ""
            let alertStartDate = DateFormatterService.shared.dateToString(
                time: Int(data.alert?.start ?? 0),
                timezoneOffset: timeOffset,
                dateType: .sunMove)
            let alertEndDate = DateFormatterService.shared.dateToString(
                time: Int(data.alert?.end ?? 0),
                timezoneOffset: timeOffset,
                dateType: .sunMove)
            self.alert = String(
                format: NSLocalizedString(
                    "alert",
                    comment: ""),
                alertEvent,
                alertDescription,
                alertStartDate,
                alertEndDate)
        }
    }
    
    func setupAdditionalWeatherInfo(data: City) {
        setupFeelsLikeInfo(data: data)
        setupSunsetInfo(data: data)
    }
    
    func setupFeelsLikeInfo(data: City) {
        let actualTemp = Int(data.weather?.temp ?? 0.0)
        let feelsLikeTemp = Int(data.weather?.feelsLike ?? 0.0)
        self.isFeelsLikeCoolerTemp = actualTemp > feelsLikeTemp ? true : false
    }
    
    func setupSunsetInfo(data: City) {
        let currentEpochTime = Int(Date().timeIntervalSince1970 * 1000.0)
        let currentHour = DateFormatterService.shared.dateToString(
            time: currentEpochTime,
            timezoneOffset: Int(data.weather?.timeOffset ?? 0),
            dateType: .comparisonHours)
        isAMtime = Int(currentHour) ?? 0 < 12 ? true : false
    }
}
