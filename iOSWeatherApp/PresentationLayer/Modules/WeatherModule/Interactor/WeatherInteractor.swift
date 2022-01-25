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
    func getWeatherData()

}

protocol WeatherInteractorOutput: AnyObject {
    func updateWeather(entity: WeatherCustomEntity)
}

