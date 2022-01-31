//
//  ChoosenCitiesPresenterImp.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 26.01.2022.
//

import Foundation

final class FavoritesPresenterImp: FavoritesPresenterInput {
    
    var locationsEntity: [LocationModel] = []
    var animationsEntity: [CellsAnimationModel] = []
    
    weak var view: FavoritesPresenterOutput?
    var interactor: FavoritesInteractorInput!
    var router: FavoritesRouterInput!
    var output: ModuleOutput?
    
    //MARK: - Protocol funcs
    
    func viewIsReady() {
        interactor.loadEntity()
    }
    
    func addCity(city: String) {
        interactor.addNewCity(city: city)
    }
    
    func dismissFavoritesScreen() {
        router.dismissScreen(output: self)
    }
    
    func getWeatherForCity(city: String, lat: Double, lon: Double) {
        interactor.configGeoModel(city: city, lat: lat, lon: lon)
    }
    
    func removeCity(index: Int) {
        interactor.removeCity(index: index)
    }
    
}

//MARK: - Extensions

extension FavoritesPresenterImp: FavoritesInteractorOutput {
    func noCityResult() {
        view?.noCityResult()
    }
    
    func updateBackground(animations: [CellsAnimationModel]) {
        animationsEntity = animations
        view?.setBackground()
    }
    
    
    func updateLocations(locations: [LocationModel]) {
        locationsEntity = locations
        view?.setLocations()
    }
    
    func updateGeoModel(model: GeoModel) {
        output?.didUpdateModel(model: model)
    }
}

extension FavoritesPresenterImp: ModuleOutput {
    func didUpdateModel(model: GeoModel) {
        
    }
}
