//
//  StorageServiceImp.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 09.01.2022.
//

import Foundation

final class StorageServiceImp: StorageService {
    
    let defaults = UserDefaults.standard
    
    // MARK: - Protocols funcs

    func setData(key: String, value: Data?) {
        defaults.set(value, forKey: key)
    }
    
    func getData(key: String) -> Data {
        defaults.data(forKey: key) ?? Data()
    }
    
}
