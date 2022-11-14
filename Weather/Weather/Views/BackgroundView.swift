//
//  BackgroundView.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 13.11.2022.
//

import SwiftUI
import SpriteKit

struct BackgroundView: View {
    
    @Binding var topBackgroundGradient: String
    @Binding var bottomBackgroundGradient: String
    @Binding var spriteKitNodes: [SpriteKitNode]
    
    var body: some View {
        
        ZStack {
            
            ForEach($spriteKitNodes, id: \.id) { scene in
                SpriteKitContainer(scene: SpriteScene(
                    nodeName: scene.name.wrappedValue,
                    topBackgroundGradientColor: .init(hex: topBackgroundGradient) ?? .gray,
                    bottomBackgroundGradientColor: .init(hex: bottomBackgroundGradient) ?? .gray))
            }
        }
        .ignoresSafeArea()
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView(
            topBackgroundGradient: .constant("000000"),
            bottomBackgroundGradient: .constant("03AF24"),
            spriteKitNodes: .constant([
                .init(name: "Rain"),
                .init(name: "Fog")
            ]))
    }
}
