//
//  AlertServiceImp.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 31.01.2022.
//

import UIKit

final class AlertServiceImp: AlertService {
    
    func noWeatherModel(vc: UIViewController, withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            alert.dismiss(animated: true)
        }))
        vc.present(alert, animated: true)
    }
    
    func noSearchResult(vc: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }

}
