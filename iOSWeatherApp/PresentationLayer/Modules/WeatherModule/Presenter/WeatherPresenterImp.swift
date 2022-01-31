//
//  WeatherPresenterImp.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 24.01.2022.
//

import Foundation

final class WeatherPresenterImp: WeatherPresenterInput {
    internal var model: GeoModel?
    
    weak var view: WeatherPresenterOutput?
    
    var storageService: StorageServiceImp!
    
    var interactor: WeatherInteractorInput!
    var router: WeatherRouterInput!
    
    //MARK: - Protocol funcs
    
    func viewIsReady() {
        interactor.locationAccessRequest()
        interactor.checkConnection()
    }
    
    func showFavorites() {
        router.showFavorites(output: self)
    }
}

//MARK: - Extensions

extension WeatherPresenterImp: WeatherInteractorOutput {
    func noWeatherModelAlert() {
        view?.noWeatherModel()
    }
    
    func updateBackground(nodes: [String], gradient: [String]) {
        view?.setBackground(nodes: nodes, gradient: gradient)
    }
    
    func updateWeather(entity: WeatherCustomEntity) {
        view?.setDataToUI(entity: entity)
    }
}

extension WeatherPresenterImp: ModuleOutput {
    func didUpdateModel(model: GeoModel) {
        interactor.getWeatherData(geoModel: model)
    }
}
