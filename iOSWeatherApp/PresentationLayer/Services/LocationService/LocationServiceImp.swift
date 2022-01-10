//
//  SpotTheCityServiceImp.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 09.01.2022.
//

import Foundation
import CoreLocation
import MapKit

final class LocationServiceImp: NSObject, LocationService, CLLocationManagerDelegate {
    var city: String = ""
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    let locationManager = CLLocationManager()
    
    func requestAccess() {
        locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestWhenInUseAuthorization()
                locationManager.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                }
            }
        }
    }
    
    func getCityName(lat: Double, lon: Double) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: lon)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
            placemarks?.forEach { (placemark) in
                if let unwrapCity = placemark.locality {
                    self.city = unwrapCity
                    print(self.city)
                }
            }
        })
    }
    
    func getUserPosition() -> CLLocationCoordinate2D? {
        requestAccess()
        locationManager.startUpdatingLocation()
        guard let location = locationManager.location?.coordinate else { return nil }
        locationManager.stopUpdatingHeading()
        lat = location.latitude
        lon = location.longitude
        return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
    
}
