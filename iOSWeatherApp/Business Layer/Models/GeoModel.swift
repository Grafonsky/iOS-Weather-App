//
//  GeoModel.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 24.01.2022.
//

import Foundation
import CoreLocation

struct GeoModel: Codable {
    var city: String
    var lat: CLLocationDegrees
    var lon: CLLocationDegrees
}
