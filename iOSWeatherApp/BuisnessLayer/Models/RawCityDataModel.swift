//
//  CityDataModel.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 10.01.2022.
//

import Foundation

struct RawCityDataModel: Codable {
    var name: String
    var country: String
    var coord: Coord
}

struct Coord: Codable {
    var lat: Double
    var lon: Double
}

//{
//    "id": 2960,
//    "name": "‘Ayn Ḩalāqīm",
//    "state": "",
//    "country": "SY",
//    "coord": {
//        "lon": 36.321911,
//        "lat": 34.940079
//    }
