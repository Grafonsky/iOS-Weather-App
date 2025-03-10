//
//  Array + ext.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 27.12.22.
//

import SwiftUI

extension Array where Element == Gradient.Stop {
    func interpolated(amount: Double) -> Color {
        guard let initialStop = self.first else {
            fatalError("Attempted to read color from empty stop array.")
        }
        
        var firstStop = initialStop
        var secondStop = initialStop
        
        for stop in self {
            if stop.location < amount {
                firstStop = stop
            } else {
                secondStop = stop
                break
            }
        }
        
        let totalDifference = secondStop.location - firstStop.location
        
        if totalDifference > 0 {
            let relativeDifference = (amount - firstStop.location) / totalDifference
            return firstStop.color.interpolated(to: secondStop.color, amount: relativeDifference)
        } else {
            return firstStop.color.interpolated(to: secondStop.color, amount: 0)
        }
    }
}
