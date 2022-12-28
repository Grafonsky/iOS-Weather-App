//
//  CitiesService.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 20.12.22.
//

import Foundation

final class CitiesService: HTTPClient {
    
    static let shared = CitiesService()
    
    func getCitiesList(nameRequest: String) async -> Result<[CityData], HTTPRequestError> {
        let result = await sendRequest(
            endpoint: CitiesEndpoint.current(nameRequest: nameRequest),
            responseModel: CityModel.self)
        switch result {
        case .success(let success):
            var result: [CityData] = []
            success.geonames.forEach { city in
                let cityData: CityData = .init(
                    id: .init(),
                    name: city.name,
                    region: city.adminName,
                    country: city.countryName,
                    code: city.countryCode,
                    lat: Double(city.lat) ?? 0.0,
                    lon: Double(city.lng) ?? 0.0)
                result.append(cityData)
            }
            return .success(result)
        case .failure(let error):
            return .failure(error)
        }
    }
    
}
