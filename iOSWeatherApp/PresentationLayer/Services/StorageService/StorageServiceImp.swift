//
//  StorageServiceImp.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 09.01.2022.
//

import Foundation

final class StorageServiceImp: StorageService {
    
    func uploadData(data: CustomWeatherModel) {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            defaults.set(encoded, forKey: "weatherData")
        }
    }
    
    func downloadData() -> CustomWeatherModel? {
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        if let result = defaults.value(forKey: "weatherData") as? Data {
            return try? decoder.decode(CustomWeatherModel.self, from: result)
        }
        return nil
    }
    
}
