//
//  WeatherApp.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 28.10.2022.
//

import SwiftUI

@main
struct WeatherApp: App {
    
    let locationService: LocationService = .init()
    
    var body: some Scene {
        WindowGroup {
            FavoritesView(viewModel: .init(locationService: locationService))
        }
    }
}
