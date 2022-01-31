//
//  UIView + extensions.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 27.01.2022.
//

import UIKit

extension UIView {
    
    func fadeIn(_ duration: TimeInterval? = 0.5, onCompletion: (() -> Void)? = nil) {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration!,
                       animations: { self.alpha = 1 },
                       completion: { (value: Bool) in
            if let complete = onCompletion { complete() }
        })
    }
    
    func makeGradient(color1: UIColor, color2: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.opacity = 1
        layer.insertSublayer(gradient, at: 0)
    }
}
