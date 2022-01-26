//
//  ChoosenCitiesInteractorImp.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 26.01.2022.
//

import Foundation

final class FavoritesInteractorImp: FavoritesInteractorInput {
    
    weak var output: FavoritesInteractorOutput?
    
    var storageService: StorageServiceImp!
    var dateFormatterService: DateFormatterService!
    var locationService: LocationServiceImp!
    var weatherService: WeatherServiceImp!
            
    //MARK: - Protocol funcs
    
    func loadEntity() {
        var locations: [LocationModel] = []
        let favorites: [LocationModel] = loadLocations().locations
        guard let currentLocation = aboutCurrentLocation() else { return }
        locations.append(currentLocation)
        locations.append(contentsOf: favorites)
        output?.updateLocations(locations: locations)
    }
    
    func addNewCity(city: String) {
        locationService.getCityGeo(city: city) { [weak self] geo in
            print(geo)
            self?.locationService.getPosition(currentLocation: geo) { [weak self] city, lat, lon in
                print(city)
                let geoModel = GeoModel.init(city: city, lat: lat, lon: lon)
                self?.weatherService.loadWeatherData(lat: geoModel.lat, lon: geoModel.lon) { [weak self] jsonData in
                    DispatchQueue.main.async {
                        guard var locations: FavoritesEntity = self?.loadLocations() else { return }
                        guard let newCity = self?.configModel(jsonData: jsonData, geoModel: geoModel)  else { return }
                        locations.locations.append(newCity)
                        self?.saveLocations(locations: locations)
                        self?.loadEntity()
                    }
                }
            }
        }
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
        let model = LocationModel.init(
            cityName: cityName,
            lat: lat,
            lon: lon,
            subTitle: subTitle,
            weatherDesc: weatherDesc,
            temp: temp,
            minTemp: minTemp,
            maxTemp: maxTemp)
        return model
    }
    
    private func loadLocations() -> FavoritesEntity {
        let data = storageService.getData(key: StorageEnum.favoritesStorageKey)
        let decoder = JSONDecoder()
        guard let entity = try? decoder.decode(FavoritesEntity.self, from: data) else { return FavoritesEntity.init(locations: []) }
        return entity
    }
    
    private func saveLocations(locations: FavoritesEntity) {
        let data = try? JSONEncoder().encode(locations)
        storageService.setData(key: StorageEnum.favoritesStorageKey, value: data)
    }
    
    private func aboutCurrentLocation() -> LocationModel? {
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
            maxTemp: entity.maxTemp)
        return current
    }
    
}
