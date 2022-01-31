//
//  Module.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 26.01.2022.
//

protocol ModuleOutput: AnyObject {
    func didUpdateModel(model: GeoModel)
}
