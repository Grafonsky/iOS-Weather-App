//
//  ChoosenCitiesPresenter.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 26.01.2022.
//

import Foundation

protocol FavoritesPresenterInput {
    var view: FavoritesPresenterOutput? { get set }
    var locationsEntity: [LocationModel] { get set }
    var animationsEntity: [CellsAnimationModel] { get set }
    
    func viewIsReady()
    func addCity(city: String)
    func dismissFavoritesScreen()
    func getWeatherForCity(city: String, lat: Double, lon: Double)
    func removeCity(index: Int)
}

protocol FavoritesPresenterOutput: AnyObject {
    func setLocations()
    func setBackground()
    func noCityResult()
    
}
