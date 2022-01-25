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
    
    func getWeatherData() {
        if !isConnected {
            guard let entity = loadEntity() else { return }
            output?.updateWeather(entity: entity)
        } else {
            guard let geoModel = loadGeoModel() else { return }
            weatherService.loadWeatherData(lat: geoModel.lat, lon: geoModel.lon, completion: { [weak self] jsonData in
                self?.configEntity(jsonData: jsonData, geoModel: geoModel)
            })
        }
    }
    
    // MARK: - Private funcs
    
    private func saveGeoModel(geoModel: GeoModel) {
        let model = try? JSONEncoder().encode(geoModel)
        storageService.setData(key: StorageEnum.geoModelStorageKey, value: model)
    }
    
    private func saveEntity(entity: WeatherCustomEntity) {
        let data = try? JSONEncoder().encode(entity)
        storageService.setData(key: StorageEnum.weatherStorageKey, value: data)
    }
    
    private func loadGeoModel() -> GeoModel? {
        let data = storageService.getData(key: StorageEnum.geoModelStorageKey)
        let decoder = JSONDecoder()
        let model = try? decoder.decode(GeoModel.self, from: data)
        return model
    }
    
    private func loadEntity() -> WeatherCustomEntity? {
        let data = storageService.getData(key: StorageEnum.weatherStorageKey)
        let decoder = JSONDecoder()
        let entity = try? decoder.decode(WeatherCustomEntity.self, from: data)
        return entity
    }

    private func configEntity(jsonData: WeatherRawEntity, geoModel: GeoModel) {
        let city = geoModel.city
        let currentTemp = String(round(jsonData.current.temp - 273.15))
        let minTemp = String(round(jsonData.daily[0].temp.min - 273.15))
        let maxTemp = String(round(jsonData.daily[0].temp.max - 273.15))
        let alert = [Alerts.init(event: "", start: 0, end: 0, description: "")]
        let desc = String(jsonData.current.weather[0].description)
        let feelsLike = String(round(jsonData.current.feels_like - 273.15))
        let humidity = String(Int(jsonData.current.humidity))
        let windSpeed = String(jsonData.current.wind_speed)
        let sunrise = String(jsonData.current.sunrise)
        let sunset = String(jsonData.current.sunset)
        let icon = jsonData.current.weather.first?.icon ?? ""
        let entity = WeatherCustomEntity(
            city: city,
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
    }
    
}

// MARK: - Extensions

extension WeatherInteractorImp: CLLocationManagerDelegate {
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locations -----> \(locations)")
        if !locations.isEmpty {
            self.currentLocation = locations.first ?? CLLocation()
            locationService.getUserPosition(currentLocation: currentLocation, completion: { [weak self] city, lat, lon in
                let newGeoData = GeoModel.init(city: city, lat: lat, lon: lon)
                self?.saveGeoModel(geoModel: newGeoData)
                self?.isConnected = true
                self?.getWeatherData()
            })
        }
    }
}
