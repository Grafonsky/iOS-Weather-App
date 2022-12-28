//
//  CloudThickness.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 28.12.22.
//

import Foundation

extension BackgroundStyleModel {
    var cloudThickness: Cloud.Thickness {
        switch self {
        case .d01:
            return .none
        case .d02:
            return .thin
        case .d03:
            return .light
        case .d04:
            return .regular
        case .d09:
            return .thick
        case .d10:
            return .none
        case .d11:
            return .none
        case .d13:
            return .none
        case .d50:
            return .none
            
        case .n01:
            return .none
        case .n02:
            return .thin
        case .n03:
            return .light
        case .n04:
            return .regular
        case .n09:
            return .thick
        case .n10:
            return .none
        case .n11:
            return .none
        case .n13:
            return .none
        case .n50:
            return .none
        }
    }
}
