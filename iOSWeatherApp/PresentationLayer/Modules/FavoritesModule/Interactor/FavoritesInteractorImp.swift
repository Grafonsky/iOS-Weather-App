//
//  ChoosenCitiesInteractorImp.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 26.01.2022.
//

import Foundation
import CoreLocation

final class FavoritesInteractorImp: FavoritesInteractorInput {
    
    weak var output: FavoritesInteractorOutput?
    
    var storageService: StorageServiceImp!
    var backgroundService: BackgroundServiceImp!
    var dateFormatterService: DateFormatterServiceImp!
    var locationService: LocationServiceImp!
    var weatherService: WeatherServiceImp!
    
    var locationsGeo: [GeoModel] = []
    var locationsList: [LocationModel] = []
    var animations: [CellsAnimationModel] = []
    
    //MARK: - Protocol funcs
    
    func loadEntity() {
        loadCitiesData()
        
    }
    
    func addNewCity(city: String) {
        locationService.getCityGeo(city: city) { [weak self] geo, error in
            if error == nil {
                guard let geo = geo else { return }
                self?.locationService.getPosition(currentLocation: geo) { [weak self] city, lat, lon, error in
                    guard let city = city else { return }
                    guard let lat = lat else { return }
                    guard let lon = lon else { return }
                    let geoModel = GeoModel.init(city: city, lat: lat, lon: lon)
                    self?.locationsGeo.append(geoModel)
                    self?.weatherService.loadWeatherData(lat: geoModel.lat, lon: geoModel.lon) { [weak self] jsonData in
                        guard let newCity = self?.configModel(jsonData: jsonData, geoModel: geoModel)  else { return }
                        self?.locationsList.append(newCity)
                        self?.saveLocations()
                        guard let nodes = self?.backgroundService.searchResultsAnimations(entity: newCity) else { return }
                        guard let gradient = self?.backgroundService.searchResultsGradient(entity: newCity) else { return }
                        self?.animations.append(CellsAnimationModel.init(nodes: nodes, gradient: gradient))
                        self?.output?.updateLocations(locations: self!.locationsList)
                        self?.output?.updateBackground(animations: self!.animations)
                    }
                }
            } else {
                self?.noCityResult()
            }
        }
    }
    
    func configGeoModel(city: String, lat: Double, lon: Double) {
        let geoModel = GeoModel.init(city: city, lat: lat, lon: lon)
        output?.updateGeoModel(model: geoModel)
    }
    
    func removeCity(index: Int) {
        locationsList.remove(at: index)
        locationsGeo.remove(at: index)
        animations.remove(at: index)
        saveLocations()
        output?.updateLocations(locations: locationsList)
        output?.updateBackground(animations: animations)
    }
    
    //MARK: - Private funcs
    
    private func configModel(jsonData: WeatherRawEntity, geoModel: GeoModel) -> LocationModel {
        let cityName = geoModel.city
        let lat = geoModel.lat
        let lon = geoModel.lon
        let subTitle = dateFormatterService.dateToString(date: NSDate.now as NSDate, format: "HH:mm")
        let weatherDesc = jsonData.current.weather[0].description
        let temp = jsonData.current.temp
        let minTemp = jsonData.daily[0].temp.min
        let maxTemp = jsonData.daily[0].temp.max
        let icon = jsonData.current.weather[0].icon
        let model = LocationModel.init(
            cityName: cityName,
            lat: lat,
            lon: lon,
            subTitle: subTitle,
            weatherDesc: weatherDesc,
            temp: temp,
            minTemp: minTemp,
            maxTemp: maxTemp,
            icon: icon)
        return model
    }
    
    private func loadCitiesData() {
        animations = []
        locationsList = []
        locationsGeo = []
        
        locationsGeo = loadLocations()
        guard let currentLocation = loadCurrentLocation() else { return }
        if locationsGeo.isEmpty {
            locationsGeo.append(currentLocation)
        } else {
            locationsGeo[0] = currentLocation
        }
        locationsGeo.flatMap { geoModel in
            self.weatherService.loadWeatherData(lat: geoModel.lat, lon: geoModel.lon) { jsonData in
                let favoriteCity = self.configModel(jsonData: jsonData, geoModel: geoModel)
                let nodes = self.backgroundService.searchResultsAnimations(entity: favoriteCity)
                let gradient = self.backgroundService.searchResultsGradient(entity: favoriteCity)
                
                self.locationsList.append(favoriteCity)
                self.animations.append(CellsAnimationModel.init(nodes: nodes, gradient: gradient))
                
                self.output?.updateLocations(locations: self.locationsList)
                self.output?.updateBackground(animations: self.animations)
            }
        }
    }
    
    private func noCityResult() {
        output?.noCityResult()
    }
    
    private func loadLocations() -> [GeoModel] {
        let decoder = JSONDecoder()
        let data = storageService.getData(key: StorageEnum.favoritesStorageKey)
        guard let locations = try? decoder.decode([GeoModel].self, from: data) else { return [] }
        return locations
    }
    
    private func loadCurrentLocation() -> GeoModel? {
        let loadedModel = storageService.getWeatherModel()
        guard let city = loadedModel?.city else { return nil }
        guard let lat = loadedModel?.lat else { return nil }
        guard let lon = loadedModel?.lon else { return nil }
        return GeoModel.init(city: city, lat: lat, lon: lon)
    }
    
    private func saveLocations() {
        let data = try? JSONEncoder().encode(locationsGeo)
        storageService.setData(key: StorageEnum.favoritesStorageKey, value: data)
    }
    
    private func configCurrentModel() -> LocationModel? {
        let data = storageService.getData(key: StorageEnum.weatherStorageKey)
        let decoder = JSONDecoder()
        guard let entity = try? decoder.decode(WeatherCustomEntity.self, from: data) else { return nil }
        let current = LocationModel.init(
            cityName: entity.city,
            lat: entity.lat,
            lon: entity.lon,
            subTitle: dateFormatterService.dateToString(date: NSDate.now as NSDate, format: "HH:mm"),
            weatherDesc: entity.desc,
            temp: entity.currentTemp,
            minTemp: entity.minTemp,
            maxTemp: entity.maxTemp,
            icon: entity.icon)
        return current
    }
    
}
