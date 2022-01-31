//
//  StringProtocol + extensions.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 23.01.2022.
//

import UIKit

extension StringProtocol {
    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
    }
}
