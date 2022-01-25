//
//  AppDelegate.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 17.01.2022.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let controller = WeatherAssembly.configWeatherModule()
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        return true
    }
}

