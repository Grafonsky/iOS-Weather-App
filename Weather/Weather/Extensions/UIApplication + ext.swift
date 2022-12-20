//
//  UIApplication + ext.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 20.12.22.
//

import UIKit

extension UIApplication {
    func dismissKeyboard() {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil)
    }
}
