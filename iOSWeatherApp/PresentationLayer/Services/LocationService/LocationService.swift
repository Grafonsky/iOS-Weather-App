//
//  LocationService.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 20.01.2022.
//

import Foundation
import CoreLocation

protocol LocationService {
    func getUserPosition(currentLocation: CLLocation, completion: @escaping (String, CLLocationDegrees, CLLocationDegrees) -> ())
}
