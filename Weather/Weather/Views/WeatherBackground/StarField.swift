//
//  StarField.swift
//  InstaWeather — https://www.patreon.com/posts/weather-app-76384109
// MARK: -
//  Instagram — https://www.instagram.com/iam_iosdev/
//  Patreon — https://www.patreon.com/danielswift/posts
// MARK: -
//
//  Created by Daniel Swift on 10/11/2022.
//

import Foundation

class StarField {
    var stars = [Star]()
    let leftEdge = -50.0
    let rightEdge = 500.0
    var lastUpdate = Date.now
    
    init() {
        for _ in 1...200 {
            let x = Double.random(in: leftEdge...rightEdge)
            let y = Double.random(in: 0...600)
            let size = Double.random(in: 1...3)
            let star = Star(x: x, y: y, size: size)
            stars.append(star)
        }
    }
    
    func update(date: Date) {
        let delta = date.timeIntervalSince1970 - lastUpdate.timeIntervalSince1970
        
        for star in stars {
            star.x -= delta * 2
            
            if star.x < leftEdge {
                star.x = rightEdge
            }
        }
        
        lastUpdate = date
    }
}
