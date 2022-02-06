//
//  DailyForecastCell.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 22.11.2021.
//

import UIKit

class DailyForecastCell: UITableViewCell {
    @IBOutlet weak var dayOfWeek: UILabel!
    @IBOutlet weak var dayTemp: UILabel!
    @IBOutlet weak var nightTemp: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
