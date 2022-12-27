//
//  RootViewModel.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 24.12.22.
//

import Foundation
import Combine
import SwiftUI

enum AccessLocationStatus {
    case allowed, notAllowed
}

@MainActor
final class RootViewModel: ObservableObject {
    
    private(set) var bag: Set<AnyCancellable>
    
    @Published var cities: [City] = []
    @Published var isLocationAllowed: Bool = false
    @Published var isLoaded: Bool = false
    
    let coreDataService = CoreDataService.shared
    let locationService: LocationService
    let accessLocationService: AccessLocationService
    let weatherService: WeatherService
    let userDefaults = UserDefaults.standard
    
    var isFirstLaunch: Bool {
        get {
            return userDefaults.object(forKey: "Weather.isFirstLaunch") as? Bool ?? true
        }
        set {
            userDefaults.setValue(newValue, forKey: "Weather.isFirstLaunch")
        }
    }
    
    init() {
        bag = .init()
        
        locationService = .init()
        accessLocationService = .init(locationService: locationService)
        weatherService = .init(locationService: locationService)
        loadCities()
        
        Task {
            isLocationAllowed = await accessLocationService.checkAuthorizationStatus()
            
            guard isLocationAllowed,
                  cities.isEmpty
            else {
                isLoaded = true
                return
            }
            
            let result = await weatherService.getCurrentTemp()
            switch result {
            case .success(_):
                isLoaded = true
            case .failure(let error):
                AlertService.shared.presentAlert(
                    title: "error".localizable,
                    message: error.errorDescription ?? "")
            }
            loadCities()
        }
    }
    
    func loadCities() {
        cities = coreDataService.getAllCities()
    }
}
