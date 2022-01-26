//
//  WeatherRouterImp.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 25.01.2022.
//

import Foundation
import UIKit

final class WeatherRouterImp: NSObject, WeatherRouterInput {
    
    weak var view: UIViewController?
    
    // MARK: - Protocol funcs
    
    func showFavorites() {
        guard let view = view, let controller = FavoritesAssembly.configFavoritesModule() else { return }
        controller.modalPresentationStyle = UIModalPresentationStyle.custom
        controller.transitioningDelegate = self
        view.present(controller, animated: true)
    }

}

// MARK: - Extension

extension WeatherRouterImp: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        WeatherPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
