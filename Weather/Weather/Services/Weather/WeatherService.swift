//
//  WeatherService.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 29.10.2022.
//

import Foundation
import Combine

final class WeatherService: HTTPClient {
    
    private let locationService: LocationService
    private let accessService: AccessLocationService
    private var store: Set<AnyCancellable> = []
    
    init(locationService: LocationService) {
        self.locationService = locationService
        self.accessService = AccessLocationService(locationService: locationService)
    }
    
    func getCurrentTemp() async -> Result<WeatherData, WeatherServiceError> {
        guard await accessService.checkAuthorizationStatus()
        else { return .failure(.locationAccess) }
        
        guard let location = await accessService.getCurrentLocation()
        else { return .failure(.location) }
        
        let result = await getTemp(lat: location.lat, lon: location.lon)
        switch result {
        case .success(let weather):
            CoreDataService.shared.saveCurrentCity(weatherData: weather)
            return .success(weather)
        case .failure(let error):
            return .failure(.network(error))
        }
    }
    
    @discardableResult
    func getTemp(cityData: CityData) async -> Result<WeatherData, HTTPRequestError> {
        let result = await sendRequest(
            endpoint: WeatherEndpoint.current(lat: cityData.lat, lon: cityData.lon),
            responseModel: WeatherModel.self)
        switch result {
        case .success(let weather):
            let weatherData: WeatherData = .init(
                city: cityData.name,
                weatherModel: weather)
            CoreDataService.shared.saveFavoriteCity(weatherData: weatherData)
            return .success(weatherData)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func getTemp(cityData: City) async -> Result<WeatherData, HTTPRequestError> {
        let result = await sendRequest(
            endpoint: WeatherEndpoint.current(lat: cityData.lat, lon: cityData.lon),
            responseModel: WeatherModel.self)
        switch result {
        case .success(let weather):
            let weatherData: WeatherData = .init(
                city: cityData.name ?? "",
                weatherModel: weather)
            return .success(weatherData)
        case .failure(let error):
            return .failure(error)
        }
    }
}

private extension WeatherService {
    
    func getTemp(lat: Double, lon: Double) async -> Result<WeatherData, HTTPRequestError> {
        let result = await sendRequest(
            endpoint: WeatherEndpoint.current(lat: lat, lon: lon),
            responseModel: WeatherModel.self)
        switch result {
        case .success(let weather):
            let weatherData: WeatherData = .init(
                city: locationService.currentCity,
                weatherModel: weather)
            return .success(weatherData)
        case .failure(let error):
            return .failure(error)
        }
    }
}
