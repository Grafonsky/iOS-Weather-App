//
//  BackgroundServiceImp.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 27.01.2022.
//

import Foundation

final class BackgroundServiceImp: BackgroundServiceInput {
    
    // MARK: - Protocols funcs
    
    func backgroundGradient(entity: WeatherCustomEntity) -> [String] {
        let gradientColors = GradientColors().colors
        for color in gradientColors {
            if entity.icon == color.key {
                return color.value
            }
        }
        return []
    }
    
    func backgroundAnimations(entity: WeatherCustomEntity) -> [String] {
        let nodes = SpriteKitNodes().nodes
        for animation in nodes {
            if entity.icon == animation.key {
                return animation.value
            }
        }
        return []
    }
    
    func searchResultsGradient(entity: LocationModel) -> [String] {
        let gradientColors = GradientColors().colors
        for color in gradientColors {
            if entity.icon == color.key {
                return color.value
            }
        }
        return []
    }
    
    func searchResultsAnimations(entity: LocationModel) -> [String] {
        let nodes = SpriteKitNodes().nodes
        for animation in nodes {
            if entity.icon == animation.key {
                return animation.value
            }
        }
        return []
    }
    
}
