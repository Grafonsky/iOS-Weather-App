//
//  SpriteKitContainer.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 13.11.2022.
//

import SwiftUI
import SpriteKit

struct SpriteKitContainer: UIViewRepresentable {
    
    var skScene: SKScene
    
    init(scene: SKScene) {
        skScene = scene
        self.skScene.scaleMode = .resizeFill
    }
    
    class Coordinator: NSObject {
        var scene: SKScene?
    }
    
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.scene = self.skScene
        return coordinator
    }
    
    func makeUIView(context: Context) -> SKView {
        let view = SKView(frame: .zero)
        view.preferredFramesPerSecond = 60
        view.showsFPS = false
        view.showsNodeCount = false
        return view
    }
    
    func updateUIView(_ view: SKView, context: Context) {
        view.presentScene(context.coordinator.scene)
    }
}

struct SpriteKitContainer_Previews: PreviewProvider {
    static var previews: some View {
        SpriteKitContainer(
            scene: SpriteScene(
                size: .init(
                    width: UIScreen.screenWidth,
                    height: UIScreen.screenHeight)))
    }
}
