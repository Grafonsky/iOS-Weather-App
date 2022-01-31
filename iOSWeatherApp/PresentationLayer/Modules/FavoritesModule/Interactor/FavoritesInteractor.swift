//
//  ChoosenCitiesInteractor.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 26.01.2022.
//

import Foundation

protocol FavoritesInteractorInput {
    var output: FavoritesInteractorOutput? { get set }
    
    func loadEntity()
    func addNewCity(city: String)
    func configGeoModel(city: String, lat: Double, lon: Double)
    func removeCity(index: Int)
}

protocol FavoritesInteractorOutput: AnyObject {
    func updateLocations(locations: [LocationModel])
    func updateGeoModel(model: GeoModel)
    func updateBackground(animations: [CellsAnimationModel])
    func noCityResult()
}
