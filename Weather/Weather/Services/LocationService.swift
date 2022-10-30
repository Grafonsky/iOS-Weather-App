//
//  LocationService.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 29.10.2022.
//

import CoreLocation
import Combine

typealias Coordinate = (lat: Double, lon: Double)

final class LocationService: NSObject, ObservableObject {
    
    static var _currentCity: CurrentValueSubject<String, Never> = .init("—")
    
    private let service: CLLocationManager = .init()
    private let geoCoder: CLGeocoder = .init()
    
    var currentLocationUpdate: PassthroughSubject<Coordinate, Never> = .init()
    var statusUpdate: PassthroughSubject<CLAuthorizationStatus, Never> = .init()
    var currentLocation: Coordinate?
    var currentCity: String = "—"
    
    var status: CLAuthorizationStatus {
        return service.authorizationStatus
    }
    var isAuthorized: Bool {
        return isAuthorizedAlways || isAuthorizedWhenUse
    }
    
    private var isAuthorizedAlways: Bool {
        return status == .authorizedAlways
    }
    private var isAuthorizedWhenUse: Bool {
        return status == .authorizedWhenInUse
    }
    
    override init() {
        super.init()
        service.delegate = self
        service.requestAlwaysAuthorization()
        service.startUpdatingLocation()
        service.desiredAccuracy = kCLLocationAccuracyBest
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first
            else { return }
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            geoCoder.reverseGeocodeLocation(location) { [weak self] placemark,_ in
                if let city = placemark?.first?.locality {
                    self?.currentCity = city
                    LocationService._currentCity.send(city)
                }
            }
            let coordinate = (lat: lat, lon: lon)
            currentLocation = coordinate
            currentLocationUpdate.send(coordinate)
            currentLocationUpdate.send(completion: .finished)
        }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard service.authorizationStatus != .notDetermined
        else { return }
        statusUpdate.send(service.authorizationStatus)
    }
    
}
