//
//  FavoritesViewModel.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 20.12.22.
//

import SwiftUI
import Combine

final class FavoritesViewModel: ObservableObject {
    
    private(set) var bag: Set<AnyCancellable> = .init()
    
    @Published var favoriteCities: [City] = []
    @Published var searchableCities: [CityData] = []
    @Published var searchText: String = ""
    @Published var isSearching = false
    @Published var isResponseReceived = false
    
    private let coreDataService: CoreDataService = .shared
    private let weatherService: WeatherService
    
    var searchTextSubject: PassthroughSubject<String, Never>
    var addCitySubject: PassthroughSubject<CityData, Never>
    var removeCitySubject: PassthroughSubject<Int, Never>
    
    init(weatherService: WeatherService) {
        searchTextSubject = .init()
        addCitySubject = .init()
        removeCitySubject = .init()
        
        self.weatherService = weatherService
        
        updateFavorites()
        binding()
    }
}

extension FavoritesViewModel {
    
    func updateFavorites() {
        DispatchQueue.main.async {
            withAnimation {
                self.favoriteCities = self.coreDataService.getAllCities()
            }
        }
    }
}

private extension FavoritesViewModel {
    
    func binding() {
        searchTextSubject
            .receive(on: DispatchQueue.main)
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [unowned self] newValue in
                Task {
                    guard !newValue.isEmpty
                    else { return }
                    let result = await CitiesService.shared.getCitiesList(nameRequest: newValue)
                    switch result {
                    case .success(let success):
                        DispatchQueue.main.async { [weak self] in
                            self?.isResponseReceived = true
                            self?.searchableCities = success
                        }
                    case .failure(let failure):
                        break
                    }
                }
            }
            .store(in: &bag)
        
        addCitySubject
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] city in
                UIApplication.shared.dismissKeyboard()
                Task {
                    await weatherService.getTemp(cityData: city)
                    updateFavorites()
                }
            }
            .store(in: &bag)
        
        removeCitySubject
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] cityIndex in
                let allCities = coreDataService.getAllCities()
                guard let cityName = allCities[cityIndex].name
                else { return }
                coreDataService.removeCity(cityName: cityName)
            }
            .store(in: &bag)
    }
    
}
