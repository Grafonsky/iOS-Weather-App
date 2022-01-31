//
//  CityCell.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 26.01.2022.
//

import UIKit
import SpriteKit

class CityCell: UITableViewCell {
    
    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxMinLabel: UILabel!
    
    // MARK: - Life cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }
    
    // MARK: - Config funcs
    
    private func config() {
        skView.layer.cornerRadius = 15
        skView.clipsToBounds = true
        self.selectionStyle = .none
    }
    
    func configBackgroud(nodes: [String], gradient: [String]) {
        let background = SKScene(size: skView.frame.size)
        skView.presentScene(background)
        
        guard let color1 = UIColor.init(hex: gradient[0]) else { return }
        guard let color2 = UIColor.init(hex: gradient[1]) else { return }
        
        let texture = SKTexture(size: CGSize(width: skView.frame.width, height: skView.frame.height),
                                color1: CIColor(color: color1),
                                color2: CIColor(color: color2),
                                direction: GradientDirection.up)
        texture.filteringMode = .linear
        let backgroundSprite = SKSpriteNode(texture: texture)
        backgroundSprite.position = CGPoint(x: skView.center.x, y: skView.center.y)
        backgroundSprite.size = skView.frame.size
        background.addChild(backgroundSprite)
        
        nodes.flatMap { [weak self] node in
            guard let animation = SKSpriteNode(fileNamed: node) else { return }
            background.addChild(animation)
            animation.position = CGPoint(x: skView.frame.width - 100, y: skView.frame.height + 75)
        }
        
    }
}
