//
//  Color + ext.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 10.11.2022.
//

import SwiftUI

enum WeatherColors {
    case cold, cool, normal, warm, warmer, hot
    
    var weatherColor: Color {
        switch self {
        case .cold:
            return .init(hex: "1d71f2")
        case .cool:
            return .init(hex: "1c9cf6")
        case .normal:
            return .init(hex: "19c3fb")
        case .warm:
            return .init(hex: "e3f4fe")
        case .warmer:
            return .init(hex: "fffae0")
        case .hot:
            return .init(hex: "ffcd00")
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    static func getWeatherColor(temp: CGFloat) -> Color {
        if temp <= 0 {
            return WeatherColors.cold.weatherColor
        } else if temp > 0 && temp <= 15 {
            return WeatherColors.cool.weatherColor
        } else if temp > 15 && temp <= 20 {
            return WeatherColors.normal.weatherColor
        } else if temp > 20 && temp <= 25 {
            return WeatherColors.warm.weatherColor
        } else if temp > 25 && temp <= 30 {
            return WeatherColors.warmer.weatherColor
        } else {
            return WeatherColors.hot.weatherColor
        }
    }
}

extension Color {
    static let midnightStart = Color(hue: 0.66, saturation: 0.8, brightness: 0.1)
    static let midnightEnd = Color(hue: 0.62, saturation: 0.5, brightness: 0.33)
    static let sunriseStart = Color(hue: 0.62, saturation: 0.6, brightness: 0.42)
    static let sunriseEnd = Color(hue: 0.95, saturation: 0.35, brightness: 0.66)
    static let sunnyDayStart = Color(hue: 0.6, saturation: 0.6, brightness: 0.6)
    static let sunnyDayEnd = Color(hue: 0.6, saturation: 0.4, brightness: 0.85)
    static let sunsetStart = Color.sunriseStart
    static let sunsetEnd = Color(hue: 0.05, saturation: 0.34, brightness: 0.65)
    
    static let darkCloudStart = Color(hue: 0.65, saturation: 0.3, brightness: 0.3)
    static let darkCloudEnd = Color(hue: 0.65, saturation: 0.3, brightness: 0.7)
    static let lightCloudStart = Color.white
    static let lightCloudEnd = Color(white: 0.75)
    static let sunriseCloudStart = Color.lightCloudStart
    static let sunriseCloudEnd = Color.sunriseEnd
    static let sunsetCloudStart = Color.lightCloudStart
    static let sunsetCloudEnd = Color.sunsetEnd
}

extension Color {
    func getComponents() -> (red: Double, green: Double, blue: Double, alpha: Double) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let uiColor = UIColor(self)
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
    
    func interpolated(to other: Color, amount: Double) -> Color {
        let componentsFrom = self.getComponents()
        let componentsTo = other.getComponents()
        
        let newRed = (1 - amount) * componentsFrom.red + (amount * componentsTo.red)
        let newGreen = (1 - amount) * componentsFrom.green + (amount * componentsTo.green)
        let newBlue = (1 - amount) * componentsFrom.blue + (amount * componentsTo.blue)
        let newOpacity = (1 - amount) * componentsFrom.alpha + (amount * componentsTo.alpha)
        
        return Color(.displayP3, red: newRed, green: newGreen, blue: newBlue, opacity: newOpacity)
    }
}
