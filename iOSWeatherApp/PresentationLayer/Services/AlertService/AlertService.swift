//
//  AlertService.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 31.01.2022.
//

import UIKit

protocol AlertService {
    func noWeatherModel(vc: UIViewController, withTitle title: String, message : String)
    func noSearchResult(vc: UIViewController, title: String, message : String)
}
