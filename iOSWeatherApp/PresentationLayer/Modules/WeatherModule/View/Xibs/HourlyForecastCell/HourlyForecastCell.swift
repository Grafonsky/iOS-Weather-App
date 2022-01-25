//
//  HourlyForecastCell.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 23.01.2022.
//

import UIKit

class HourlyForecastCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherPic: UIImageView!
    @IBOutlet weak var degreesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
