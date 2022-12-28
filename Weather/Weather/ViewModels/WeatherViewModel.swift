//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 29.10.2022.
//

import SwiftUI
import Combine
import Network

// MARK: - Enum WeatherType

enum WeatherType {
    case current, favorite(data: City)
    
    var cityData: City? {
        switch self {
        case .current:
            return nil
        case .favorite(let city):
            return city
        }
    }
    
    static func ==(lhs: WeatherType, rhs: WeatherType) -> Bool {
        return lhs.cityData?.weather == rhs.cityData?.weather
    }
}

// MARK: - WeatherViewModel

final class WeatherViewModel: ObservableObject {
    
    typealias HourlyForecast = (icon: String, date: String, temp: String)
    typealias DailyForecast = (icon: String, date: String, minTemp: CGFloat, maxTemp: CGFloat, isCurrentDay: Bool)
    typealias Alert = (event: String, description: String, start: Int, end: Int)
    
    private(set) var bag: Set<AnyCancellable> = .init()
    
    @Published private(set) var cityName: String?
    @Published private(set) var temp: String?
    
    @Published var weatherDescription: String?
    @Published var icon: String?
    @Published var weatherType: WeatherType = .current
    @Published var isLoaded: Bool = false
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
    @Published var networkStatus: NWPath.Status = .satisfied
    
    var minWeekTemp: CGFloat = 999
    var maxWeekTemp: CGFloat = -999
    var currentTemp: CGFloat = 999
    var isFeelsLikeCoolerTemp: Bool = false
    var isAMtime: Bool = false
    var timeOffset: Int = 0
    
    private let weatherService: WeatherService
    private let coreDataService: CoreDataService
    private let monitorQueue = DispatchQueue(label: "monitor")
    
    init(weatherType: WeatherType, locationService: LocationService) {
        self.weatherService = .init(locationService: locationService)
        self.coreDataService = CoreDataService.shared
        self.loadData(weatherType: weatherType)
        
        NWPathMonitor()
            .publisher(queue: monitorQueue)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                withAnimation {
                    if self?.networkStatus != status {
                        self?.networkStatus = status
                        self?.loadData(weatherType: weatherType)
                    }
                }
            }
            .store(in: &bag)
    }
}

// MARK: - Setup Data

private extension WeatherViewModel {
    
    func loadData(weatherType: WeatherType) {
        switch weatherType {
        case .current:
            LocationService._currentCity
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] newValue in
                    self?.loadFromCoreData(weatherType: weatherType)
                    if newValue != self?.cityName ?? "" {
                        self?.updateData(weatherType: .current)
                    } else {
                        guard Date.isLastUpdateMoreThanHour()
                        else { return }
                        self?.updateData(weatherType: .current)
                    }
                })
                .store(in: &bag)
        case .favorite(_):
            guard let cityData = weatherType.cityData
            else { break }
            self.updateUI(data: cityData)
            self.updateData(weatherType: .favorite(data: cityData))
        }
    }
    
    func updateData(weatherType: WeatherType) {
        switch weatherType {
        case .current:
            Task {
                let weather = await weatherService.getCurrentTemp()
                switch weather {
                case .success(_):
                    loadFromCoreData(weatherType: .current)
                case .failure(let error):
                    AlertService.shared.presentAlert(
                        title: "error".localizable,
                        message: error.errorDescription ?? "")
                }
            }
        case .favorite(let cityData):
            Task {
                guard Date.isLastUpdateMoreThanHour(city: cityData)
                else { return }
                let weather = await weatherService.getTemp(cityData: cityData)
                switch weather {
                case .success(let weatherData):
                    coreDataService.updateCity(
                        city: cityData,
                        weatherData: weatherData)
                    self.updateUI(data: cityData)
                case .failure(let error):
                    AlertService.shared.presentAlert(
                        title: "error".localizable,
                        message: error.errorDescription ?? "")
                }
            }
        }
    }
    
    func loadFromCoreData(weatherType: WeatherType) {
        DispatchQueue.main.async { [weak self] in
            switch weatherType {
            case .current:
                guard let savedData = CoreDataService.shared.getAllCities().first
                else { return }
                self?.updateUI(data: savedData)
            case .favorite(let data):
                self?.updateUI(data: data)
            }
        }
    }
    
    func updateUI(data: City) {
        DispatchQueue.main.async { [weak self] in
            self?.timeOffset = Int(data.weather?.timeOffset ?? 0)
            self?.setupData(data: data)
            self?.setupHourlyForecast(data: data)
            self?.setupDailyForecast(data: data)
            self?.setupAlerts(data: data)
            self?.setupAdditionalWeatherInfo(data: data)
            self?.isLoaded = true
        }
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
        self.windSpeed = "\(data.weather?.windSpeed ?? 0.0)"
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
            let icon = BackgroundStyleModel(rawValue: hourly.element.icon ?? "")?.icon ?? ""
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
            let icon = BackgroundStyleModel(rawValue: daily.element.icon ?? "")?.icon ?? ""
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
