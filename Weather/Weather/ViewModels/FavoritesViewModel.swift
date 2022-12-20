//
//  FavoritesViewModel.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 20.12.22.
//

import Foundation
import Combine

final class FavoritesViewModel: ObservableObject {
    
    var anyCancellable: Set<AnyCancellable> = .init()
    
    @Published var favoriteCities: [City]
    @Published var searchText: String = ""
    @Published var isSearching = false
    @Published var searchableCities: [CityData] = []
    
    private let coreDataService = CoreDataService.shared
    private let weatherService: WeatherService
    
    var searchTextSubject: PassthroughSubject<String, Never>
    var addCitySubject: PassthroughSubject<CityData, Never>
    
    init(locationService: LocationService) {
        searchTextSubject = .init()
        addCitySubject = .init()
        
        weatherService = .init(locationService: locationService)
        
        favoriteCities = coreDataService.getAllCities()
        
        searchTextSubject
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] newValue in
                Task {
                    let result = await CitiesService.shared.getCitiesList(nameRequest: newValue)
                    switch result {
                    case .success(let success):
                        DispatchQueue.main.async { [weak self] in
                            self?.searchableCities = success
                        }
                    case .failure(let failure):
                        break
                    }
                }
            }
            .store(in: &anyCancellable)
        
        addCitySubject
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] city in
                Task {
                    print(city)
                }
            }
            .store(in: &anyCancellable)
    }
}
