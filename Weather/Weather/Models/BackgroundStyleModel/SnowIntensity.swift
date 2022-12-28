//
//  SnowIntensity.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 28.12.22.
//

import Foundation

enum SnowIntensity: String {
    case light              = "light snow"
    case snow               = "snow"
    case heavySnow          = "heavy snow"
    case sleet              = "sleet"
    case lightSleet         = "light shower sleet"
    case showerSleet        = "shower sleet"
    case lightRainSnow      = "light rain and snow"
    case rainSnow           = "Rain and snow"
    case lightShowerSnow    = "Light shower snow"
    case showerSnow         = "Shower snow"
    case heavyShowerSnow    = "Heavy shower snow"
}

extension SnowIntensity {
    
    var intensity: Int {
        switch self {
        case .light:
            return 25
        case .snow:
            return 175
        case .heavySnow:
            return 500
        case .sleet:
            return 50
        case .lightSleet:
            return 25
        case .showerSleet:
            return 100
        case .lightRainSnow:
            return 25
        case .rainSnow:
            return 100
        case .lightShowerSnow:
            return 25
        case .showerSnow:
            return 100
        case .heavyShowerSnow:
            return 200
        }
    }
}
