//
//  SetCityModuleImp.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 10.01.2022.
//

import Foundation

final class SetCityPresenterImp: SetCityPresenterInput {
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    var citiesData: [CustomCityDataModel] = []
    var filteredTableData: [CustomCityDataModel] = []
    
    var inputWeather: WeatherPresenterInput? = WeatherPresenterImp()

    func viewIsReady() {
        parseCitiesList()
    }
    
    func parseCitiesList() {
        guard let path = Bundle.main.path(forResource: "city.list", ofType: "json") else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let result = try JSONDecoder().decode([RawCityDataModel].self, from: data)
            var i = 0
            while i < result.count {
                citiesData.append(CustomCityDataModel.init(name: result[i].name, country: result[i].country, lat: result[i].coord.lat, lon: result[i].coord.lon))
                i += 1
            }
        } catch {
            print(error)
        }
    }
    
    func transferCityData(transferedLat: Double, transferedLon: Double) {
        inputWeather?.geoByUser = true
        inputWeather?.lat = transferedLat
        inputWeather?.lon = transferedLon
        inputWeather?.updateWeather()
    }
    
}
