//
//  ChoosenCitiesPresenterImp.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 26.01.2022.
//

import Foundation

final class FavoritesPresenterImp: FavoritesPresenterInput {
    weak var view: FavoritesPresenterOutput?
    var interactor: FavoritesInteractorInput!
    
    var locationsEntity: [LocationModel] = []

    //MARK: - Protocol funcs

    func viewIsReady() {
        interactor.loadEntity()
    }
    
    func addCity(city: String) {
        interactor.addNewCity(city: city)
    }
    
}

//MARK: - Extensions

extension FavoritesPresenterImp: FavoritesInteractorOutput {
    func updateLocations(locations: [LocationModel]) {
        locationsEntity = locations
        view?.setLocations()
    }
}
