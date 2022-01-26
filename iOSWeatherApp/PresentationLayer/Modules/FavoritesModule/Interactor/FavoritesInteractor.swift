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

}

protocol FavoritesInteractorOutput: AnyObject {
    func updateLocations(locations: [LocationModel])
}
