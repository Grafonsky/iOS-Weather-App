//
//  CityData.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 20.12.22.
//

import Foundation

struct CityData: Identifiable {
    var id: UUID
    var name: String
    var region: String
    var country: String
    var code: String
    var lat: Double
    var lon: Double
}

extension CityData {
    
    static var mock: CityData {
        .init(
            id: .init(),
            name: "Mosty Vel\'ke",
            region: "L'vivs'ka Oblast'",
            country: "Ukraine",
            code: "UA",
            lat: 50.24329,
            lon: 24.1423)
    }
    
}
