//
//  String + ext.swift
//  iOSWeather
//
//  Created by Bohdan Hawrylyshyn on 9.10.2022.
//

import Foundation

extension String {
    
    var localizable: String {
        return NSLocalizedString(self, comment: "")
    }
}
