//
//  WeatherPresenterImp.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 24.01.2022.
//

import Foundation

final class WeatherPresenterImp: WeatherPresenterInput {
    
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
        router.showFavorites()
    }
}

//MARK: - Extensions

extension WeatherPresenterImp: WeatherInteractorOutput {
    func updateWeather(entity: WeatherCustomEntity) {
        view?.setDataToUI(entity: entity)
    }
}

extension WeatherPresenterImp: ModuleOuput {
    func didUpdateModel(model: GeoModel) {
        
    }
}
