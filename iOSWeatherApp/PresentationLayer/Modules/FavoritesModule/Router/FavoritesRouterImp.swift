//
//  ChoosenCitiesRouterImp.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 26.01.2022.
//

import UIKit

final class FavoritesRouterImp: FavoritesRouterInput {
    
    weak var view: UIViewController?
    
    // MARK: - Protocol funcs
    
    func dismissScreen(output: ModuleOutput) {
        guard let view = view else { return }
        view.dismiss(animated: true)
    }
    
    
}
