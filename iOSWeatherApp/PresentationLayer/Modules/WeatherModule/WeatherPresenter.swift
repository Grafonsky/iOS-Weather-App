//
//  WeatherPresenter.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 08.01.2022.
//

import Foundation

protocol WeatherPresenterInput {
    var outputWeatherPresenter: WeatherPresenterOutput? { get set }
    var inputSetCityPresenter: SetCityPresenterInput? { get set }

    var rawWeatherModel: RawWeatherModel { get set }
    var customWeatherModel: CustomWeatherModel { get set }
    var lat: Double { get set }
    var lon: Double { get set }
    var geoByUser: Bool { get set }
    
    func viewIsReady()
    func updateWeather()
    func getWeatherData(lat: Double, lon: Double)
    func saveToCustomModel(data: RawWeatherModel)
    func detectLocation()
}

protocol WeatherPresenterOutput: AnyObject {
    func setDataToUI()
    func setWeatherImage(weatherDesc: String)
}
