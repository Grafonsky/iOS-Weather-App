//
//  ChoosenCitiesAssembly.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 26.01.2022.
//

import UIKit

final class FavoritesAssembly {
    static func configFavoritesModule(output: ModuleOutput?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "FavoritesView", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "FavoritesView") as? FavoritesViewController else { return UIViewController() }
        
        let presenter = FavoritesPresenterImp()
        let interactor = FavoritesInteractorImp()
        let router = FavoritesRouterImp()
        
        let dateFormatterService = DateFormatterServiceImp()
        let backgroundService = BackgroundServiceImp()
        let storageService = StorageServiceImp()
        let locationService = LocationServiceImp()
        let weatherService = WeatherServiceImp()
        let alertService = AlertServiceImp()
        
        presenter.interactor = interactor
        presenter.view = controller
        presenter.router = router
        presenter.output = output
        
        interactor.dateFormatterService = dateFormatterService
        interactor.storageService = storageService
        interactor.locationService = locationService
        interactor.weatherService = weatherService
        interactor.output = presenter
        interactor.backgroundService = backgroundService
        
        controller.presenter = presenter
        controller.locationService = locationService
        controller.dateFormatterService = dateFormatterService
        controller.alertService = alertService
        
        router.view = controller
        
        return controller
    }
}
