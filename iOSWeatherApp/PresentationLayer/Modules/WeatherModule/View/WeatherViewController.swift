//
//  WeatherViewController.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 17.01.2022.
//

import Foundation
import UIKit
import SpriteKit

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
    
    // Wind speed outlets
    @IBOutlet weak var windSpeedView: UIVisualEffectView!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    // Humidity outlets
    @IBOutlet weak var humidityView: UIVisualEffectView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var humidityDegreesLabel: UILabel!
    
    // Hourly outlets
    @IBOutlet weak var hourlyView: UIVisualEffectView!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    
    // Daily outlets
    @IBOutlet weak var dailyView: UIVisualEffectView!
    @IBOutlet weak var dailyForecastLabel: UILabel!
    @IBOutlet weak var dailyNightLabel: UILabel!
    @IBOutlet weak var DailyDayLabel: UILabel!
    @IBOutlet weak var dailyTableView: UITableView!
    
    // SpriteKit
    @IBOutlet weak var skView: SKView!
    
    var presenter: WeatherPresenterInput!
    var weatherEntity: WeatherCustomEntity?
    
    var dateFormatterService: DateFormatterServiceImp!
    var alertService: AlertServiceImp!
    
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewIsReady()
        config()
        
    }
    
    // MARK: - Configs
    
    private func config() {
        configAlert()
        configFeelsLike()
        configWindSpeed()
        configHumidity()
        hourlyConfig()
        configCollectionView()
        dailyConfig()
        configTableView()
    }
    
    private func configBackgroud(nodes: [String], gradient: [String]) {
        let background = SKScene(size: view.frame.size)
        skView.presentScene(background)
        
        guard let color1 = UIColor.init(hex: gradient[0]) else { return }
        guard let color2 = UIColor.init(hex: gradient[1]) else { return }
        
        let texture = SKTexture(size: CGSize(width: view.frame.width, height: view.frame.height),
                                color1: CIColor(color: color1),
                                color2: CIColor(color: color2),
                                direction: GradientDirection.up)
        texture.filteringMode = .linear
        let backgroundSprite = SKSpriteNode(texture: texture)
        backgroundSprite.position = CGPoint(x: view.center.x, y: view.center.y)
        backgroundSprite.size = view.frame.size
        background.addChild(backgroundSprite)
        
        nodes.flatMap { [weak self] node in
            guard let animation = SKSpriteNode(fileNamed: node) else { return }
            background.addChild(animation)
            animation.position = CGPoint(x: view.frame.width - 100, y: view.frame.height)
        }
        skView.fadeIn()
    }
    
    private func configAlert() {
        alertView.clipsToBounds = true
        alertView.layer.cornerRadius = 15
    }
    
    private func configFeelsLike() {
        feelsLikeView.clipsToBounds = true
        feelsLikeView.layer.cornerRadius = 15
    }
    
    private func configWindSpeed() {
        windSpeedView.clipsToBounds = true
        windSpeedView.layer.cornerRadius = 15
    }
    
    private func configHumidity() {
        humidityView.clipsToBounds = true
        humidityView.layer.cornerRadius = 15
    }
    
    private func hourlyConfig() {
        hourlyView.clipsToBounds = true
        hourlyView.layer.cornerRadius = 15
    }
    
    private func configCollectionView() {
        hourlyCollectionView.backgroundColor = .clear
        hourlyCollectionView.delegate = self
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.register(UINib(nibName: "HourlyForecastCell", bundle: nil), forCellWithReuseIdentifier: "HourlyForecastCell")
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
        guard let unwrapEntity = weatherEntity else { return }
        cityNameLabel.text = unwrapEntity.city
        degreesLabel.text = "\(unwrapEntity.currentTemp)°"
        weatherDescLabel.text = unwrapEntity.desc.firstUppercased
        maxMinLabel.text = "H:\(unwrapEntity.maxTemp)° L:\(unwrapEntity.minTemp)°"
        alertDescLabel.text = "There's no danger"
        feelsLikeDegreesLabel.text = "\(unwrapEntity.feelsLike)°"
        windSpeedLabel.text = "\(unwrapEntity.windSpeed) m/s"
        humidityDegreesLabel.text = "\(unwrapEntity.humidity)%"
    }
    
    private func showNoWeatherModelAlert() {
        alertService.noWeatherModel(vc: self,
                                    withTitle: "No Internet Connection!",
                                    message: "It's first time launching app, so we need an Internet connection to save weather at you location")
    }
    
    // MARK: - Actions
    
    @IBAction func ActionShowChoosenCities(_ sender: Any) {
        presenter.showFavorites()
    }
}

// MARK: - Extensions

extension WeatherViewController: WeatherPresenterOutput {
    func noWeatherModel() {
        showNoWeatherModelAlert()
    }
    
    func setBackground(nodes: [String], gradient: [String]) {
        configBackgroud(nodes: nodes, gradient: gradient)
    }
    
    func setDataToUI(entity: WeatherCustomEntity) {
        weatherEntity = entity
        configDataToUI()
        dailyTableView.reloadData()
        hourlyCollectionView.reloadData()
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let entity = weatherEntity else { return 0 }
        return entity.dailyForecast.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let forecast = weatherEntity?.dailyForecast else { return UITableViewCell() }
        let daily = forecast[indexPath.row]
        if let cell = dailyTableView.dequeueReusableCell(withIdentifier: "DailyForecastCell", for: indexPath) as? DailyForecastCell {
            cell.backgroundColor = .clear
            cell.isUserInteractionEnabled = false
            let icon = daily.weather[0].icon
            let iconsDict = WeatherIconsModel()
            guard let unwrapIcon = iconsDict.iconsDict[icon] else { return UITableViewCell() }
            
            cell.weatherIcon.image = UIImage(systemName: unwrapIcon)
            cell.dayOfWeek.text = dateFormatterService.dailyDateFormatter(date: daily.dt)
            cell.dayTemp.text = "\(round(daily.temp.max - 273.15))°"
            cell.nightTemp.text = "\(round(daily.temp.min - 273.15))°"
            return cell
        }
        return UITableViewCell()
    }
}

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = weatherEntity?.hourlyForecast.count else { return 0 }
        if count != 0 {
            return 24
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = hourlyCollectionView.dequeueReusableCell(withReuseIdentifier: "HourlyForecastCell", for: indexPath) as? HourlyForecastCell {
            cell.backgroundColor = .clear
            guard let hourly = weatherEntity?.hourlyForecast[indexPath.row] else { return UICollectionViewCell() }
            let temp = hourly.temp
            let icon = hourly.weather[0].icon
            let time = hourly.dt
            let iconsDict = WeatherIconsModel()
            guard let unwrapIcon = iconsDict.iconsDict[icon] else { return UICollectionViewCell() }
            
            cell.degreesLabel.text = "\(round(temp - 273.15))°"
            cell.weatherPic.image = UIImage(systemName: unwrapIcon)
            cell.timeLabel.text = dateFormatterService.hourlyDateFormatter(date: hourly.dt)
            
            return cell
        }
        return UICollectionViewCell()
    }
}
