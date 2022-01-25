//
//  WeatherAssembly.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 17.01.2022.
//

import UIKit

final class WeatherAssembly {
    static func configWeatherModule() -> UIViewController? {
        let storyboard = UIStoryboard(name: "WeatherView", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "WeatherView") as? WeatherViewController else { return UIViewController() }
        
        let presenter = WeatherPresenterImp()
        let interactor = WeatherInteractorImp()
        let router = WeatherRouterImp()
        
        let weatherService = WeatherServiceImp()
        let locationService = LocationServiceImp()
        let storageService = StorageServiceImp()
        let dateFormatterService = DateFormatterServiceImp()
        
        presenter.interactor = interactor
        presenter.view = controller
        presenter.router = router
        
        interactor.output = presenter
        interactor.weatherService = weatherService
        interactor.storageService = storageService
        interactor.locationService = locationService
        
        controller.presenter = presenter
        controller.dateFormatterService = dateFormatterService
        
        router.view = controller
        
        return controller
    }
}
