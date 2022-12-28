//
//  UIWindow + ext.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 27.12.22.
//

import UIKit

extension UIWindow {
    class var keyWindow: UIWindow? {
        get {
            return UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        }
    }
    
    class func topController(base: UIViewController? = keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController,
           let visible = nav.visibleViewController {
            return topController(base: visible)
        }
        if let tab = base as? UITabBarController,
           let selected = tab.selectedViewController {
            return topController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topController(base: presented)
        }
        return base
    }
}
