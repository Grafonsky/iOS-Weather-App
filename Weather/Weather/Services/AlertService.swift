//
//  AlertService.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 27.12.22.
//

import UIKit

final class AlertService {
    
    static let shared = AlertService()
    
    private var isAlertShowed = false
    
    func presentAlert(
        title: String,
        okActionTitle: String = "OK",
        message: String,
        completion: (() -> Void)? = nil) {
            guard !isAlertShowed
            else { return }
            isAlertShowed = true
            
            let title = title
            let message = message
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: okActionTitle, style: .default, handler: { _ in
                completion?()
                self.isAlertShowed = false
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(okAction)
            
            DispatchQueue.main.async {
                UIWindow.topController()?.present(alert, animated: true, completion: nil)
            }
        }
}
