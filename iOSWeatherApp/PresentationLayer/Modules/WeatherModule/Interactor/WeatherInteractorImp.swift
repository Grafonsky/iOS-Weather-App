//
//  WeatherInteractorImp.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 24.01.2022.
//

import Foundation
import CoreLocation


final class WeatherInteractorImp: NSObject, WeatherInteractorInput {
    weak var output: WeatherInteractorOutput?
    
    var locationService: LocationServiceImp!
    var storageService: StorageServiceImp!
    var weatherService: WeatherServiceImp!
    var backgroundService: BackgroundServiceImp!
    
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    var isConnected: Bool = false
    
    // MARK: - Protocol funcs
    
    func locationAccessRequest() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func checkConnection() {
        if !isConnected {
            guard let entity = loadEntity() else { return }
            output?.updateWeather(entity: entity)
        }
    }
    
    func getWeatherData(geoModel: GeoModel) {
        weatherService.loadWeatherData(lat: geoModel.lat, lon: geoModel.lon, completion: { [weak self] jsonData in
            self?.configEntity(jsonData: jsonData, geoModel: geoModel)
        })
    }
    
    // MARK: - Private funcs
    
    private func saveEntity(entity: WeatherCustomEntity) {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(entity)
        storageService.setData(key: StorageEnum.weatherStorageKey, value: data)
    }
    
    private func loadEntity() -> WeatherCustomEntity? {
        let decoder = JSONDecoder()
        let data = storageService.getData(key: StorageEnum.weatherStorageKey)
        let entity = try? decoder.decode(WeatherCustomEntity.self, from: data)
        return entity
    }
    
    private func configEntity(jsonData: WeatherRawEntity, geoModel: GeoModel) {
        let city = geoModel.city
        let lat = geoModel.lat
        let lon = geoModel.lon
        let currentTemp = round(jsonData.current.temp - 273.15)
        let minTemp = round(jsonData.daily[0].temp.min - 273.15)
        let maxTemp = round(jsonData.daily[0].temp.max - 273.15)
        let alert = [Alerts.init(event: "", start: 0, end: 0, description: "")]
        let desc = jsonData.current.weather[0].description
        let feelsLike = round(jsonData.current.feels_like - 273.15)
        let humidity = jsonData.current.humidity
        let windSpeed = jsonData.current.wind_speed
        let sunrise = jsonData.current.sunrise
        let sunset = jsonData.current.sunset
        let icon = jsonData.current.weather.first?.icon ?? ""
        let entity = WeatherCustomEntity(
            city: city,
            lat: lat,
            lon: lon,
            currentTemp: currentTemp,
            minTemp: minTemp,
            maxTemp: maxTemp,
            alert: alert,
            desc: desc,
            feelsLike: feelsLike,
            humidity: humidity,
            windSpeed: windSpeed,
            sunrise: sunrise,
            sunset: sunset,
            hourlyForecast: jsonData.hourly,
            dailyForecast: jsonData.daily,
            icon: icon)
        saveEntity(entity: entity)
        output?.updateWeather(entity: entity)
        output?.updateBackground(
            nodes: backgroundService.backgroundAnimations(entity: entity),
            gradient: backgroundService.backgroundGradient(entity: entity))
    }
    
    private func saveCurrentLocation(geoModel: GeoModel) {
        storageService.saveWeatherModel(model: geoModel)
    }
    
}

// MARK: - Extensions

extension WeatherInteractorImp: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            self.currentLocation = locations.first ?? CLLocation()
            locationService.getPosition(currentLocation: currentLocation, completion: { [weak self] city, lat, lon, error in
                if error == nil {
                    guard let city = city else { return }
                    guard let lat = lat else { return }
                    guard let lon = lon else { return }
                    let newGeoData = GeoModel.init(city: city, lat: lat, lon: lon)
                    self?.getWeatherData(geoModel: newGeoData)
                    self?.saveCurrentLocation(geoModel: newGeoData)
                    self?.isConnected = true
                } else {
                    self?.output?.noWeatherModelAlert()
                }
                
            })
        }
    }
}
