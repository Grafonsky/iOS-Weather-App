//
//  LocationServiceImp.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 09.01.2022.
//

import Foundation
import CoreLocation
import MapKit

final class LocationServiceImp: NSObject, LocationService, CLLocationManagerDelegate {
    
    var currentCityName = ""
    let locationManager = CLLocationManager()
    
    // MARK: - Protocols funcs

    func getUserPosition(currentLocation: CLLocation, completion: @escaping (String, CLLocationDegrees, CLLocationDegrees) -> ()) {
        let geoCoder = CLGeocoder()
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        let location = CLLocation(latitude: lat, longitude: lon)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { [weak self] (placemarks, _) -> Void in
            guard let placemark = placemarks?.first else { return }
            if self?.currentCityName == "" {
                guard let cityName = placemark.locality else { return }
                self?.currentCityName = cityName
                completion(cityName, lat, lon)
            }
        })
    }
}
