//
//  WeatherApp.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 28.10.2022.
//

import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            FavoritesView(viewModel: .init())
        }
    }
}
