//
//  StorageService.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 09.01.2022.
//

import Foundation

protocol StorageService {
    func uploadData(data: CustomWeatherModel)
    func downloadData() -> CustomWeatherModel?
}
