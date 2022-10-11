//
//  TabBarBackground.swift
//  iOSWeather
//
//  Created by Bohdan Hawrylyshyn on 11.10.2022.
//

import SwiftUI

struct TabBarClipShape: Shape {
    
    var tabMidPoint: CGFloat
    
    var animatableData: CGFloat {
        get { return tabMidPoint }
        set { tabMidPoint = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        let path: Path = .init { path in
            path.move(to: CGPoint( x: rect.width , y: rect.height))
            path.addLine(to: CGPoint( x: rect.width , y: 0))
            path.addLine(to: CGPoint( x: 0 , y: 0))
            path.addLine(to: CGPoint( x: 0 , y: rect.height))
            
            let mid = tabMidPoint
            
            path.move(to: CGPoint( x: mid - 40 , y: rect.height))
            
            let to = CGPoint( x: mid , y: rect.height - 20)
            let contour1 = CGPoint( x: mid - 15 , y: rect.height)
            let contour2 = CGPoint( x: mid - 15 , y: rect.height - 20)
            
            let to1 = CGPoint( x: mid + 40 , y: rect.height)
            let contour3 = CGPoint( x: mid + 15 , y: rect.height - 20)
            let contour4 = CGPoint( x: mid + 15 , y: rect.height)
            
            path.addCurve(to: to, control1: contour1, control2: contour2)
            path.addCurve(to: to1, control1: contour3, control2: contour4)
        }
        return path
    }
}
