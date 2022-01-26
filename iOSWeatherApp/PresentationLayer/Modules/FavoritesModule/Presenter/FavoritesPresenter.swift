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

    func viewIsReady()
    func addCity(city: String)
}

protocol FavoritesPresenterOutput: AnyObject {
    func setLocations()

}
