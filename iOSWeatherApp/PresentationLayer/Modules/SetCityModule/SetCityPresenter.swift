//
//  SetCityModule.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 10.01.2022.
//

import Foundation

protocol SetCityPresenterInput {
    var citiesData: [CustomCityDataModel] { get set }
    var filteredTableData: [CustomCityDataModel] { get set }
    var inputWeather: WeatherPresenterInput? { get set }
    
    var lat: Double { get set }
    var lon: Double { get set }
    
    func viewIsReady()
    func parseCitiesList()
    func transferCityData(transferedLat: Double, transferedLon: Double)
}
