//
//  Star.swift
//  InstaWeather — https://www.patreon.com/posts/weather-app-76384109
// MARK: -
//  Instagram — https://www.instagram.com/iam_iosdev/
//  Patreon — https://www.patreon.com/danielswift/posts
// MARK: -
//
//  Created by Daniel Swift on 10/11/2022.
//

import Foundation

class Star {
    var x: Double
    var y: Double
    var size: Double
    var flickerInterval: Double
    
    init(x: Double, y: Double, size: Double) {
        self.x = x
        self.y = y
        self.size = size
        
        if size > 2 && y < 250 {
            flickerInterval = Double.random(in: 3...20)
        } else {
            flickerInterval = 0
        }
    }
}
