//
//  IsRainOn.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 28.12.22.
//

import Foundation

extension BackgroundStyleModel {
    
    var isRainOn: Bool {
        switch self {
        case .d01:
            return false
        case .d02:
            return false
        case .d03:
            return false
        case .d04:
            return false
        case .d09:
            return true
        case .d10:
            return true
        case .d11:
            return true
        case .d13:
            return true
        case .d50:
            return false
            
        case .n01:
            return false
        case .n02:
            return false
        case .n03:
            return false
        case .n04:
            return false
        case .n09:
            return true
        case .n10:
            return true
        case .n11:
            return true
        case .n13:
            return true
        case .n50:
            return false
        }
    }
}
