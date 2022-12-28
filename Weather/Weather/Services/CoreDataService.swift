//
//  CoreDataService.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 29.11.22.
//

import CoreData
import UIKit

class CoreDataService: ObservableObject {
    
    static let shared = CoreDataService()
    
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "WeatherEntity")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Core Data Store failed \(error.localizedDescription)")
            }
        }
    }
}

extension CoreDataService {
    
    func getAllCities() -> [City] {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func saveWeather() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save weather \(error)")
        }
    }
    
    func saveCurrentCity(weatherData: WeatherData) {
        let context = persistentContainer.viewContext
        let allCities = getAllCities()
        let currentCity = allCities.first
        
        guard currentCity != nil
        else {
            let currentCity: City = .init(context: context)
            currentCity.name = weatherData.city
            currentCity.lat = weatherData.weatherModel.lat
            currentCity.lon = weatherData.weatherModel.lon
            currentCity.weather = weatherDataToCoreData(weatherData: weatherData)
            currentCity.lastUpdate = Date.currentTimeStamp
            saveWeather()
            return
        }
        
        currentCity?.name = weatherData.city
        currentCity?.weather = weatherDataToCoreData(weatherData: weatherData)
        currentCity?.alert = alertToCoreData(weatherData: weatherData)
        currentCity?.lastUpdate = Date.currentTimeStamp
        saveWeather()
    }
    
    func saveFavoriteCity(weatherData: WeatherData) {
        let _: City? = cityDataToCoreData(weatherData: weatherData)
        saveWeather()
    }
    
    func removeCity(cityName: String) {
        let context = persistentContainer.viewContext
        let allCities = getAllCities()
        var selectedCity: City? = nil
        allCities.forEach { city in
            if city.name == cityName {
                selectedCity = city
            }
        }
        
        guard let selectedCity = selectedCity,
              selectedCity != allCities.first
        else { return }
        context.delete(selectedCity)
        saveWeather()
    }
    
    func updateCity(city: City, weatherData: WeatherData) {
        DispatchQueue.main.async { [weak self] in
            city.weather = self?.weatherDataToCoreData(weatherData: weatherData)
            city.lastUpdate = Date.currentTimeStamp
            self?.saveWeather()
        }
    }
}

private extension CoreDataService {
    
    func cityDataToCoreData(weatherData: WeatherData) -> City? {
        let context = persistentContainer.viewContext
        let city: City = .init(context: context)
        
        city.name = weatherData.city
        city.lat = weatherData.weatherModel.lat
        city.lon = weatherData.weatherModel.lon
        city.weather = weatherDataToCoreData(weatherData: weatherData)
        city.alert = alertToCoreData(weatherData: weatherData)
        
        return city
    }
    
    func alertToCoreData(weatherData: WeatherData) -> Alert? {
        let context = persistentContainer.viewContext
        let lastAlert = weatherData.weatherModel.alerts?.last
        let alert: Alert = .init(context: context)
        
        alert.event = lastAlert?.event
        alert.start = Int64(lastAlert?.start ?? 0)
        alert.end = Int64(lastAlert?.end ?? 0)
        alert.alertDescription = lastAlert?.description
        return alert
    }
    
    func weatherDataToCoreData(weatherData: WeatherData) -> Weather? {
        let context = persistentContainer.viewContext
        let weather: Weather = .init(context: context)
        
        weatherData.weatherModel.daily.forEach { daily in
            let weatherDaily: Daily = .init(context: context)
            let currentDay = DateFormatterService.shared.dateToString(
                time: Int(Date().timeIntervalSince1970),
                timezoneOffset: weatherData.weatherModel.timeOffset,
                dateType: .weekDay)
            let date = DateFormatterService.shared.dateToString(
                time: daily.date,
                timezoneOffset: weatherData.weatherModel.timeOffset,
                dateType: .weekDay)
            let isCurrentDay = date == currentDay ? true : false
            
            weatherDaily.weather = weather
            weatherDaily.date = Int64(daily.date)
            weatherDaily.icon = daily.weather.first?.icon
            weatherDaily.isCurrentDay = isCurrentDay
            weatherDaily.maxTemp = daily.temp.max
            weatherDaily.minTemp = daily.temp.min
        }
        
        weatherData.weatherModel.hourly.forEach { hourly in
            let weatherHourly: Hourly = .init(context: context)
            weatherHourly.weather = weather
            weatherHourly.date = Int64(hourly.date)
            weatherHourly.icon = hourly.weather.first?.icon
            weatherHourly.temp = hourly.temp
        }
        
        let icon = weatherData.weatherModel.current.weather.first?.icon
        if weatherData.weatherModel.alerts != nil {
            let alertEvent = weatherData.weatherModel.alerts?.last?.event ?? ""
            let alertDescription = weatherData.weatherModel.alerts?.last?.description ?? ""
            let alertStartDate = DateFormatterService.shared.dateToString(
                time: weatherData.weatherModel.alerts?.last?.start ?? 0,
                timezoneOffset: weatherData.weatherModel.timeOffset,
                dateType: .sunMove)
            let alertEndDate = DateFormatterService.shared.dateToString(
                time: weatherData.weatherModel.alerts?.last?.end ?? 0,
                timezoneOffset: weatherData.weatherModel.timeOffset,
                dateType: .sunMove)
            weather.alert = String(
                format: NSLocalizedString(
                    "alert",
                    comment: ""),
                alertEvent,
                alertDescription,
                alertStartDate,
                alertEndDate)
        }
        weather.feelsLike = weatherData.weatherModel.current.feelsLike
        weather.humidity = weatherData.weatherModel.current.humidity
        weather.icon = weatherData.weatherModel.current.weather.first?.icon
        weather.maxTemp = weatherData.weatherModel.daily.first?.temp.max ?? 0.0
        weather.minTemp = weatherData.weatherModel.daily.first?.temp.min ?? 0.0
        weather.sunrise = Int64(weatherData.weatherModel.current.sunrise)
        weather.sunset = Int64(weatherData.weatherModel.current.sunset)
        weather.temp = weatherData.weatherModel.current.temp
        weather.weatherDescription = weatherData.weatherModel.current.weather.first?.description
        weather.windSpeed = weatherData.weatherModel.current.windSpeed
        weather.timeOffset = Int64(weatherData.weatherModel.timeOffset)
        
        return weather
    }
}
