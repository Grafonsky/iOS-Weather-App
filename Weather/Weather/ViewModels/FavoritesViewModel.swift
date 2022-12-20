//
//  FavoritesViewModel.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 20.12.22.
//

import Foundation

final class FavoritesViewModel: ObservableObject {
    
    @Published var cities: [City]
    @Published var searchText: String = ""
    @Published var isSearching = false
    
    private let coreDataService = CoreDataService.shared
    
    init() {
        cities = coreDataService.getAllCities()
    }
    
}
