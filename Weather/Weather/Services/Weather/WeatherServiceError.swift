//
//  WeatherServiceError.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 29.10.2022.
//

import Foundation

enum WeatherServiceError: Error {
    case network(HTTPRequestError)
    case location
    case locationAccess
}

extension WeatherServiceError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .network(let httpRequestError):
            return "🛑 Network error: \(httpRequestError.localizedDescription)"
        case .location:
            return "🛑 No location data"
        case .locationAccess:
            return "🛑 No access to location data"
        }
    }
}
