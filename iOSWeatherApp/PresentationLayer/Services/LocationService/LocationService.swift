//
//  LocationService.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 20.01.2022.
//

import Foundation
import CoreLocation

protocol LocationService {
    func getPosition(currentLocation: CLLocation, completion: @escaping (String, CLLocationDegrees, CLLocationDegrees) -> ())
    func getCityGeo(city: String, completion: @escaping (CLLocation) -> ())
}
