//
//  Cloud.swift
//  InstaWeather — https://www.patreon.com/posts/weather-app-76384109
// MARK: -
//  Instagram — https://www.instagram.com/iam_iosdev/
//  Patreon — https://www.patreon.com/danielswift/posts
// MARK: -
//
//  Created by Daniel Swift on 10/11/2022.
//

import Foundation

class Cloud {
    enum Thickness: CaseIterable {
        case none, thin, light, regular, thick, ultra
    }
    
    var position: CGPoint
    let imageNumber: Int
    let speed = Double.random(in: 4...12)
    let scale: Double
    
    init(imageNumber: Int, scale: Double) {
        self.imageNumber = imageNumber
        self.scale = scale
        
        let startX = Double.random(in: -400...400)
        let startY = Double.random(in: -50...200)
        position = CGPoint(x: startX, y: startY)
    }
}
