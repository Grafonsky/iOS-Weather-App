//
//  WeatherServiceImp.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 20.01.2022.
//

import Foundation
import CoreLocation

final class WeatherServiceImp: WeatherService {
    
    // MARK: - Protocol funcs
    
    func loadWeatherData(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping (WeatherRawEntity) -> ()) {
        let session: URLSession = URLSession.shared
        guard let url = prepareRequest(lat: lat, lon: lon) else { return }
        let request: URLRequest = URLRequest(url: url)
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let parsedData = self?.parseWeatherData(
                    data: data as NSData?,
                    response: response as URLResponse?,
                    error: error as NSError?) else { return }
                completion(parsedData)
            }
        }
        task.resume()
    }
    
    // MARK: - Private funcs
    
    private func prepareRequest(lat: CLLocationDegrees, lon: CLLocationDegrees) -> URL? {
        var components = URLComponents(string: OWAPIEnum.url)
        components?.queryItems = [URLQueryItem(name: QueryItemEnum.lat, value: String(lat)),
                                  URLQueryItem(name: QueryItemEnum.lon, value: String(lon)),
                                  URLQueryItem(name: QueryItemEnum.exclude, value: QueryItemEnum.exclude),
                                  URLQueryItem(name: QueryItemEnum.units, value: QueryItemEnum.units),
                                  URLQueryItem(name: QueryItemEnum.appid, value: OWAPIEnum.apiKey)
        ]
        return components?.url
    }
    
    private func parseWeatherData(data: NSData?, response: URLResponse?, error: NSError?) -> WeatherRawEntity? {
        if error == nil && data != nil {
            let decoder = JSONDecoder()
            guard let unwrapData = data else { return nil }
            if let jsonData = try? decoder.decode(WeatherRawEntity.self, from: unwrapData as Data) {
                return jsonData
            }
        }
        return nil
    }
}
