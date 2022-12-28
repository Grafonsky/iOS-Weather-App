//
//  WeatherIconModel.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 28.12.22.
//

import Foundation

extension BackgroundStyleModel {
    
    var icon: String {
        switch self {
        case .d01:
            return "sun.max.fill"
        case .d02:
            return "cloud.sun.fill"
        case .d03:
            return "cloud.fill"
        case .d04:
            return "smoke.fill"
        case .d09:
            return "cloud.drizzle.fill"
        case .d10:
            return "cloud.sun.rain.fill"
        case .d11:
            return "cloud.bolt.rain.fill"
        case .d13:
            return "snowflake"
        case .d50:
            return "cloud.fog.fill"
            
        case .n01:
            return "moon.stars.fill"
        case .n02:
            return "cloud.moon.fill"
        case .n03:
            return "cloud.fill"
        case .n04:
            return "smoke.fill"
        case .n09:
            return "cloud.drizzle.fill"
        case .n10:
            return "cloud.moon.rain.fill"
        case .n11:
            return "cloud.bolt.rain.fill"
        case .n13:
            return "snowflake"
        case .n50:
            return "cloud.fog.fill"
        }
    }
}
