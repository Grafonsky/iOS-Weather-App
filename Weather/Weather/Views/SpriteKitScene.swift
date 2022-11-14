//
//  SpriteKitScene.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 14.11.2022.
//

import UIKit
import SpriteKit

final class SpriteScene: SKScene {
    
    var nodeName: String = ""
    var topBackgroundGradientColor: UIColor = .clear
    var bottomBackgroundGradientColor: UIColor = .clear
    
    var backgroundSprite: SKSpriteNode = .init()
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(
        nodeName: String,
        topBackgroundGradientColor: UIColor,
        bottomBackgroundGradientColor: UIColor) {
            
            self.init(size: .init(width: UIScreen.screenWidth, height: UIScreen.screenHeight))
            self.nodeName = nodeName
            self.topBackgroundGradientColor = topBackgroundGradientColor
            self.bottomBackgroundGradientColor = bottomBackgroundGradientColor
            addScene()
        }
}

extension SpriteScene {
    
    func addScene() {
        
        let screenSize: CGSize = .init(
            width: UIScreen.screenWidth,
            height: UIScreen.screenHeight)
        let texture = SKTexture(
            size: screenSize,
            color1: CIColor(color: topBackgroundGradientColor),
            color2: CIColor(color: bottomBackgroundGradientColor),
            direction: GradientDirection.up)
        
        backgroundSprite.texture = texture
        backgroundSprite.color = .clear
        backgroundSprite.position = .init(x: UIScreen.screenWidth / 2, y: UIScreen.screenHeight / 2)
        backgroundSprite.size = screenSize
        backgroundSprite.color = .clear
        addChild(backgroundSprite)
        
        guard let animation = SKSpriteNode(fileNamed: nodeName) else { return }
        backgroundSprite.addChild(animation)
        animation.position = CGPoint(x: UIScreen.screenWidth / 2, y: UIScreen.screenHeight / 2)
    }
}
