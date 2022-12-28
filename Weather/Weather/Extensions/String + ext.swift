//
//  String + ext.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 30.10.2022.
//

import Foundation

extension String {
    
    var localizable: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
}
