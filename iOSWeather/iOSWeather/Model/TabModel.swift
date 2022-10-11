//
//  TabModel.swift
//  iOSWeather
//
//  Created by Bohdan Hawrylyshyn on 11.10.2022.
//

import SwiftUI

enum TabModel {
    case weather
    case cities
}

extension TabModel {
    
    var tabName: String {
        switch self {
        case .weather:
            return "weather".localizable
        case .cities:
            return "cities".localizable
        }
    }
    
    var selectedIconName: String {
        switch self {
        case .weather:
            return "WeatherSelectedIcon"
        case .cities:
            return "CitiesSelectedIcon"
        }
    }
    
    var nonSelectedIconName: String {
        switch self {
        case .weather:
            return "WeatherNonSelectedIcon"
        case .cities:
            return "CitiesNonSelectedIcon"
        }
    }
    
    var selectedColor: Color {
        switch self {
        case .weather, .cities:
            return Color("SelectedTabColor")
        }
    }
    
    var nonSelectedColor: Color {
        switch self {
        case .weather, .cities:
            return Color("NonSelectedTabColor")
        }
    }
    
}
