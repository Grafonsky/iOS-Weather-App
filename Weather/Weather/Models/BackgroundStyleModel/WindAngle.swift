//
//  WindAngle.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 28.12.22.
//

import Foundation

enum WindAngle {
    case current(speed: String)
}

extension WindAngle {
    var angle: Double {
        switch self {
        case .current(let speed):
            let doubleSpeed = Double(speed) ?? 0.0
            switch doubleSpeed {
            case 0...2:         return 2.5
            case 2...5:         return 5
            case 6...11:        return 7.5
            case 12...19:       return 10
            case 20...28:       return 12.5
            case 29...38:       return 15
            case 39...49:       return 20
            case 50...61:       return 25
            case 62...74:       return 30
            case 75...88:       return 35
            case 89...102:      return 45
            case 103...117:     return 55
            case 118...:        return 65
            default:            return 0
            }
        }
    }
}
