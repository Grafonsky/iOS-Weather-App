//
//  BackgroundService.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 27.01.2022.
//

import Foundation

protocol BackgroundServiceInput {
    func backgroundGradient(entity: WeatherCustomEntity) -> [String]
    func backgroundAnimations(entity: WeatherCustomEntity) -> [String]
    func searchResultsGradient(entity: LocationModel) -> [String]
    func searchResultsAnimations(entity: LocationModel) -> [String]
    
}

protocol BackgroundServiceOutput {
    
}
