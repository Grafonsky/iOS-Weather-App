//
//  SpotTheCityService.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 09.01.2022.
//

import Foundation
import CoreLocation

protocol LocationService {
    
    var city: String { get set }
    var lat: Double { get set }
    var lon: Double { get set }
    
    func getCityName(lat: Double, lon: Double)
    func getUserPosition() -> CLLocationCoordinate2D?
}
