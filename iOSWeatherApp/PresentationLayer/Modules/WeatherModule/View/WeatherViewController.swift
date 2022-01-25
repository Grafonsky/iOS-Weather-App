//
//  WeatherViewController.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 17.01.2022.
//

import Foundation
import UIKit

class WeatherViewController: UIViewController {
    
    // Weather outlets
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var weatherDescLabel: UILabel!
    @IBOutlet weak var maxMinLabel: UILabel!
    
    // Alert outlets
    @IBOutlet weak var alertView: UIVisualEffectView!
    @IBOutlet weak var alertDescLabel: UILabel!
    
    // Feels like outlets
    @IBOutlet weak var feelsLikeView: UIVisualEffectView!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var feelsLikeDegreesLabel: UILabel!
    
    // Humidity Info
    @IBOutlet weak var humidityView: UIVisualEffectView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var humidityDegreesLabel: UILabel!
    
    // Daily forecast outlets
    @IBOutlet weak var dailyView: UIVisualEffectView!
    @IBOutlet weak var dailyForecastLabel: UILabel!
    @IBOutlet weak var dailyNightLabel: UILabel!
    @IBOutlet weak var DailyDayLabel: UILabel!
    @IBOutlet weak var dailyTableView: UITableView!
    
    var presenter: WeatherPresenterInput!
    var weatherEntity: WeatherCustomEntity!

    var dateFormatterService: DateFormatterService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        presenter.viewIsReady()
    }
    
    // MARK: - Configs
    
    private func config() {
        configAlert()
        configFeelsLike()
        configHumidity()
        dailyConfig()
        configTableView()
    }
    
    private func configAlert() {
        alertView.clipsToBounds = true
        alertView.layer.cornerRadius = 15
    }
    
    private func configFeelsLike() {
        feelsLikeView.clipsToBounds = true
        feelsLikeView.layer.cornerRadius = 15
    }
    
    private func configHumidity() {
        humidityView.clipsToBounds = true
        humidityView.layer.cornerRadius = 15
    }
    
    private func dailyConfig() {
        dailyView.clipsToBounds = true
        dailyView.layer.cornerRadius = 15
    }
    
    private func configTableView() {
        dailyTableView.backgroundColor = .clear
        dailyTableView.delegate = self
        dailyTableView.dataSource = self
        dailyTableView.register(UINib(nibName: "DailyForecastCell", bundle: nil), forCellReuseIdentifier: "DailyForecastCell")
    }
    
    private func configDataToUI() {
        cityNameLabel.text = weatherEntity.city
        degreesLabel.text = "\(weatherEntity.currentTemp)°"
        weatherDescLabel.text = weatherEntity.desc.firstUppercased
        maxMinLabel.text = "Max.: \(weatherEntity.maxTemp)°, min.: \(weatherEntity.minTemp)°"
        alertDescLabel.text = "There's no danger"
        feelsLikeDegreesLabel.text = "\(weatherEntity.feelsLike)°"
        humidityDegreesLabel.text = "\(weatherEntity.humidity)%"
    }
}

    // MARK: - Extensions

extension WeatherViewController: WeatherPresenterOutput {
    func setDataToUI(entity: WeatherCustomEntity) {
        weatherEntity = entity
        configDataToUI()
        dailyTableView.reloadData()
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let entity = weatherEntity else { return 0 }
        return entity.dailyForecast.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let forecast = weatherEntity.dailyForecast
        let daily = forecast[indexPath.row]
        if let cell = dailyTableView.dequeueReusableCell(withIdentifier: "DailyForecastCell", for: indexPath) as? DailyForecastCell {
            cell.backgroundColor = .clear
            let dayOfWeek = weatherEntity.dailyForecast[indexPath.row]
            let icon = daily.weather[0].icon
            let iconsDict = WeatherIconsModel()
            guard let unwrapIcon = iconsDict.iconsDict[icon] else { return UITableViewCell() }

            cell.weatherIcon.image = UIImage(systemName: unwrapIcon)
            cell.dayOfWeek.text = dateFormatterService.dailyDateFormatter(date: dayOfWeek.dt)
            cell.dayTemp.text = "\(round(dayOfWeek.temp.max - 273.15))°"
            cell.nightTemp.text = "\(round(dayOfWeek.temp.min - 273.15))°"
            return cell
        }
        return UITableViewCell()
    }
}
