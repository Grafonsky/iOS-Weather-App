
//  AccessLocationService.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 29.10.2022.
//

import Foundation
import Combine

final class AccessLocationService {
    private let locationService: LocationService
    private var store: Set<AnyCancellable> = []
    
    init(locationService: LocationService) {
        self.locationService = locationService
    }
}

extension AccessLocationService {
    
    @discardableResult
    func checkAuthorizationStatus() async -> Bool {
        guard !locationService.isAuthorized
        else { return true }
        
        return await withCheckedContinuation({ continuation in
            locationService.statusUpdate
                .sink { status in
                    switch status {
                    case .authorizedWhenInUse:
                        continuation.resume(returning: true)
                    case .authorizedAlways:
                        continuation.resume(returning: true)
                    default:
                        continuation.resume(returning: false)
                    }
                }
                .store(in: &store)
        })
    }
    
    func getCurrentLocation() async -> Coordinate? {
        guard locationService.currentLocation == nil
        else { return locationService.currentLocation}
        
        return await withCheckedContinuation({ continuation in
            locationService.currentLocationUpdate
                .sink { (lat, lon) in
                    return continuation.resume(returning: (lat: lat, lon: lon))
                }
                .store(in: &store)
        })
    }
    
}
