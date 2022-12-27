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
    @State var sceneState: SceneState
    
    var body: some View {
        
        ZStack {
            ForEach($spriteKitNodes, id: \.id) { scene in
                SpriteKitContainer(scene: SpriteScene(
                    nodeName: scene.name.wrappedValue,
                    topBackgroundGradientColor: .init(hex: topBackgroundGradient) ?? .gray,
                    bottomBackgroundGradientColor: .init(hex: bottomBackgroundGradient) ?? .gray,
                    sceneState: sceneState))
            }
        }
        .ignoresSafeArea()
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView(
            topBackgroundGradient: .constant("a1c4fd"),
            bottomBackgroundGradient: .constant("c2e9fb"),
            spriteKitNodes: .constant([
                .init(name: "Sun")
            ]),
            sceneState: .fullscreen)
    }
}
