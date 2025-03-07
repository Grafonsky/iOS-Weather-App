//
//  ResidueDrop.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 28.12.22.
//

import SwiftUI

class ResidueDrop: Hashable {
    var id = UUID()
    var destructionTime: Double
    var x: Double
    var y = 0.5
    var scale: Double
    var speed: Double
    var opacity: Double
    var xMovement: Double
    var yMovement: Double

    init(type: Storm.Contents, xPosition: Double, destructionTime: Double) {
        self.x = xPosition
        self.destructionTime = destructionTime

        switch type {
        case .snow:
            scale = Double.random(in: 0.125...0.75)
            opacity = Double.random(in: 0.2...0.7)
            speed = 0
            xMovement = 0
            yMovement = 0
        default:
            scale = Double.random(in: 0.4...0.5)
            opacity = Double.random(in: 0...0.3)
            speed = 2

            let direction = Angle.degrees(.random(in: 225...315)).radians
            xMovement = cos(direction)
            yMovement = sin(direction) / 1.5
        }
    }

    static func ==(lhs: ResidueDrop, rhs: ResidueDrop) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
