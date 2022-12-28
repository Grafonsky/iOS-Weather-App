//
//  Date + ext.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 27.12.22.
//

import Foundation

extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970)
    }
    
    static func isLastUpdateMoreThanHour(city: City? = nil) -> Bool {
        var res = false
        if city != nil {
            let timeDifference = Date.currentTimeStamp - (city?.lastUpdate ?? 0)
            res = timeDifference >= 600
        } else {
            let current = CoreDataService.shared.getAllCities().first
            let timeDifference = Date.currentTimeStamp - (current?.lastUpdate ?? 0)
            res = timeDifference >= 600
        }
        return res
    }
}
