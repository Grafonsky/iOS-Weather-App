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
    let geoCoder = CLGeocoder()
    
    // MARK: - Protocols funcs
    
    func getPosition(currentLocation: CLLocation, completion: @escaping (String, CLLocationDegrees, CLLocationDegrees) -> ()) {
           let lat = currentLocation.coordinate.latitude
           let lon = currentLocation.coordinate.longitude
           let location = CLLocation(latitude: lat, longitude: lon)
           geoCoder.reverseGeocodeLocation(location, completionHandler: { [weak self] (placemarks, _) -> Void in
               guard let placemark = placemarks?.first else { return }
               guard let cityName = placemark.locality else { return }
               if self?.currentCityName != cityName {
                   self?.currentCityName = cityName
                   completion(cityName, lat, lon)
               }
           })
       }
    
    func getCityGeo(city: String, completion: @escaping (CLLocation) -> ()) {
        geoCoder.geocodeAddressString(city) { geo, error in
            guard let location = geo?.first?.location else { return }
            completion(location)
        }
    }
    
}
