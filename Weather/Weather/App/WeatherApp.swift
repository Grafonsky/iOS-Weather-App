//
//  WeatherApp.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 28.10.2022.
//

import SwiftUI

@main
struct WeatherApp: App {
    
    @ObservedObject var viewModel: RootViewModel
    
    init() {
        self.viewModel = .init()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(
                viewModel: viewModel,
                locationService: viewModel.locationService)
        }
    }
}
