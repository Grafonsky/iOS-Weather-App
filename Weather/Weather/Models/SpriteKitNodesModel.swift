//
//  SpriteKitNodesModel.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 13.11.2022.
//

struct SpriteKitNode: Identifiable {
    var name: String
    var id: String {
        self.name
    }
}

struct SpriteKitNodes {
    let nodes: [String: [SpriteKitNode]] = [
        "01d": [.init(name: "Sun")],
        "02d": [.init(name: "Sun"), .init(name: "Clouds")],
        "03d": [.init(name: "Clouds")],
        "04d": [.init(name: "Clouds")],
        "09d": [.init(name: "Rain"), .init(name: "Clouds")],
        "10d": [.init(name: "Rain"), .init(name: "Clouds")],
        "11d": [.init(name: "Rain"), .init(name: "Clouds")],
        "13d": [.init(name: "Snow"), .init(name: "Clouds")],
        "50d": [.init(name: "Fog"), .init(name: "Clouds")],
        
        "01n": [.init(name: "Stars")],
        "02n": [.init(name: "Stars"), .init(name: "Clouds")],
        "03n": [.init(name: "Clouds")],
        "04n": [.init(name: "Clouds")],
        "09n": [.init(name: "Rain"), .init(name: "Clouds")],
        "10n": [.init(name: "Rain"), .init(name: "Clouds")],
        "11n": [.init(name: "Rain"), .init(name: "Clouds")],
        "13n": [.init(name: "Stars"), .init(name: "Snow"), .init(name: "Clouds")],
        "50n": [.init(name: "Stars"), .init(name: "Fog"), .init(name: "Clouds")]
    ]
}
