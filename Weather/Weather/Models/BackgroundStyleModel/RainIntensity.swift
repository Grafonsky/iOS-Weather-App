//
//  RainIntensity.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 28.12.22.
//

import Foundation

enum RainIntensity: String {
    case light              = "light rain"
    case moderate           = "moderate rain"
    case heavy              = "heavy intensity rain"
    case veryHeavy          = "very heavy rain"
    case extreme            = "extreme rain"
    case freezing           = "freezing rain"
    case lightShower        = "light intensity shower rain"
    case shower             = "shower rain"
    case heavyShower        = "heavy intensity shower rain"
    case ragged             = "ragged shower rain"
}

extension RainIntensity {
    var intensity: Int {
        switch self {
        case .light:
            return 25
        case .moderate:
            return 175
        case .heavy:
            return 550
        case .veryHeavy:
            return 1000
        case .extreme:
            return 1500
        case .freezing:
            return 50
        case .lightShower:
            return 200
        case .shower:
            return 250
        case .heavyShower:
            return 750
        case .ragged:
            return 5
        }
    }
}
