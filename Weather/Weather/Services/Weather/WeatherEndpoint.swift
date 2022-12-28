//
//  WeatherEndpoint.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 29.10.2022.
//

import Foundation

enum WeatherEndpoint {
    case current(lat: Double, lon: Double)
}

extension WeatherEndpoint: Endpoint {
    
    var baseURL: URL? {
        var components: URLComponents = .init()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
    
    var path: String {
        switch self {
        case .current:
            return "/data/2.5/onecall"
        }
    }
    
    var queryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = .init()
        let apiKey: String = "21ab5af043dced2b4111a3a29a5f7097"
        
        switch self {
        case .current(let lat, let lon):
            let latItem: URLQueryItem = .init(name: "lat", value: "\(lat)")
            let lonItem: URLQueryItem = .init(name: "lon", value: "\(lon)")
            let keyItem: URLQueryItem = .init(name: "appid", value: apiKey)
            let units: URLQueryItem = .init(name: "units", value: "metric")
            let locale = Locale.current.identifier.components(separatedBy: "_").first ?? "en"
            print("🗣️ Selected language: \(locale)")
            let lang: URLQueryItem = .init(name: "lang", value: locale)
            queryItems = [latItem, lonItem, keyItem, units, lang]
            return queryItems
        }
    }
    
    var method: HTTPRequestMethod {
        switch self {
        case .current:
            return .get
        }
    }
    
    var header: [String : String]? {
        var header: [String: String] = [:]
        header["Content-Type"] = "application/json; charset=utf-8"
        return header
    }
    
    var body: [String : String]? {
        return nil
    }
    
}
