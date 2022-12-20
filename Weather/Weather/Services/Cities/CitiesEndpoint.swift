//
//  CitiesEndpoint.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 20.12.22.
//

import Foundation

enum CitiesEndpoint {
    case current(nameRequest: String)
}

extension CitiesEndpoint: Endpoint {
    var baseURL: URL? {
        var components: URLComponents = .init()
        components.scheme = "http"
        components.host = "api.geonames.org"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
    
    var queryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = .init()
        let username: String = "grafonsky"
        switch self {
        case .current(let nameRequest):
            let typeItem: URLQueryItem = .init(name: "type", value: "json")
            let citiesItem: URLQueryItem = .init(name: "cities", value: "cities5000")
            let maxRowsItem: URLQueryItem = .init(name: "maxRows", value: "1000")
            let locale = Locale.current.identifier.components(separatedBy: "_").first ?? "en"
            print("🗣️ Selected language: \(locale)")
            let langItem: URLQueryItem = .init(name: "lang", value: locale)
            let usernameItem: URLQueryItem = .init(name: "username", value: username)
            let nameRequestItem: URLQueryItem = .init(name: "name_startsWith", value: nameRequest)
            queryItems = [nameRequestItem, typeItem, citiesItem, maxRowsItem, langItem, usernameItem]
            return queryItems
        }
    }
    
    var path: String {
        switch self {
        case .current:
            return "/search"
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
