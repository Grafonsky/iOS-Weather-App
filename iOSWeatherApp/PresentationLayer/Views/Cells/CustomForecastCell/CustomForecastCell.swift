//
//  CustomForecastCell.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 22.11.2021.
//

import UIKit

class CustomForecastCell: UITableViewCell {
    @IBOutlet weak var dayOfWeek: UILabel!
    @IBOutlet weak var dayTemp: UILabel!
    @IBOutlet weak var nightTemp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
