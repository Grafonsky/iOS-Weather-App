//
//  WeatherService.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 20.01.2022.
//

import Foundation
import CoreLocation

protocol WeatherService {
    func loadWeatherData(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping (WeatherRawEntity) -> ())
}
