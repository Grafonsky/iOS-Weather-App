//
//  ChoosenCitiesAssembly.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 26.01.2022.
//

import UIKit

final class FavoritesAssembly {
    static func configFavoritesModule() -> UIViewController? {
        let storyboard = UIStoryboard(name: "FavoritesView", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "FavoritesView") as? FavoritesViewController else { return UIViewController() }
        
        let presenter = FavoritesPresenterImp()
        let interactor = FavoritesInteractorImp()
        let router = FavoritesRouterImp()
        
        let dateFormatterService = DateFormatterServiceImp()
        let storageService = StorageServiceImp()
        let locationService = LocationServiceImp()
        let weatherService = WeatherServiceImp()
        
        presenter.interactor = interactor
        presenter.view = controller
        
        interactor.dateFormatterService = dateFormatterService
        interactor.storageService = storageService
        interactor.locationService = locationService
        interactor.weatherService = weatherService
        interactor.output = presenter
        
        controller.presenter = presenter
        controller.dateFormatterService = dateFormatterService
        
        return controller
    }
}
