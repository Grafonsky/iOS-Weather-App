//
//  WeatherPresenter.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 24.01.2022.
//

import Foundation

protocol WeatherPresenterInput {
    var view: WeatherPresenterOutput? { get set }
    func viewIsReady()
    func showChoosenCities()
}

protocol WeatherPresenterOutput: AnyObject {
    func setDataToUI(entity: WeatherCustomEntity)
}

