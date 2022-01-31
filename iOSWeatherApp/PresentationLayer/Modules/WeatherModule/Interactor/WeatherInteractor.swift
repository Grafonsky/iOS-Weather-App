//
//  WeatherInteractor.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 24.01.2022.
//

import Foundation

protocol WeatherInteractorInput {
    var output: WeatherInteractorOutput? { get set }
    
    func locationAccessRequest()
    func checkConnection()
    func getWeatherData(geoModel: GeoModel)
}

protocol WeatherInteractorOutput: AnyObject {
    func updateWeather(entity: WeatherCustomEntity)
    func updateBackground(nodes: [String], gradient: [String])
    func noWeatherModelAlert()
}

