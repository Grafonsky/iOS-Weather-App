//
//  CityCell.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 26.01.2022.
//

import UIKit

class CityCell: UITableViewCell {

    @IBOutlet weak var back: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxMinLabel: UILabel!
    
    // MARK: - Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }
    
    // MARK: - Configs
    
    private func config() {
        back.clipsToBounds = true
        back.layer.cornerRadius = 15
    }

}
