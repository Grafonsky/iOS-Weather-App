//
//  ViewController.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 08.01.2022.
//

import UIKit
import Foundation

class WeatherController: UIViewController {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var forecastView: UIVisualEffectView!
    @IBOutlet weak var forecast5DayTableView: UITableView!
    @IBOutlet weak var humidityWindView: UIVisualEffectView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var bgWeatherImage: UIImageView!
    
    var input: WeatherPresenterInput = WeatherPresenterImp()
    
    //MARK: - Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        input.viewIsReady()
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
    }
    
    //MARK: - Configuration
    
    private func config() {
        configPresenter()
        configCustomViews()
        configTableView()
    }
    
    func configPresenter() {
        input.outputWeatherPresenter = self
    }
    
    private func configTableView() {
        forecast5DayTableView.backgroundColor = .clear
        forecast5DayTableView.isScrollEnabled = false
        forecast5DayTableView.delegate = self
        forecast5DayTableView.dataSource = self
        forecast5DayTableView.register(UINib(nibName: "CustomForecastCell", bundle: nil), forCellReuseIdentifier: "CustomForecastCell")
    }
    
    private func configCustomViews() {
        forecastView.clipsToBounds = true
        forecastView.layer.cornerRadius = 25
        humidityWindView.clipsToBounds = true
        humidityWindView.layer.cornerRadius = 25
    }
    
    //MARK: - Actions
    
    @IBAction func actionDetectLocation(_ sender: Any) {
        input.updateWeather()
    }
    
    @IBAction func actionOpenSetCityController(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "SetCityController") as? SetCityController {
            present(vc, animated: true)
        }
    }
    
}

    //MARK: - Extensions

extension WeatherController: WeatherPresenterOutput {
    func setDataToUI() {
        let data = input.customWeatherModel
        cityNameLabel.text = data.city
        degreesLabel.text = String(data.temp)
        weatherDescriptionLabel.text = data.desc.firstUppercased
        feelsLikeLabel.text = "Feels like: \(data.feelsLike)"
        humidityLabel.text = "☔ Humidity: \(data.humidity)"
        windSpeedLabel.text = "💨 Wind speed: \(data.windSpeed)"
        setWeatherImage(weatherDesc: data.desc)
        forecast5DayTableView.reloadData()
    }
    
    func setWeatherImage(weatherDesc: String) {
        if weatherDesc.contains("clear") {
            weatherImage.image = UIImage(named: "clear.png")
            bgWeatherImage.image = UIImage(named: "bgClear.jpg")
        } else if weatherDesc.contains("clouds") {
            weatherImage.image = UIImage(named: "cloudy.png")
            bgWeatherImage.image = UIImage(named: "bgCloudy.jpg")
        } else if weatherDesc.contains("fog") {
            weatherImage.image = UIImage(named: "fog.png")
            bgWeatherImage.image = UIImage(named: "bgFog.jpg")
        } else if weatherDesc.contains("partly cloudy") {
            weatherImage.image = UIImage(named: "partlyCloudy.png")
            bgWeatherImage.image = UIImage(named: "bgPartlyCloudy.jpg")
        } else if weatherDesc.contains("shower") {
            weatherImage.image = UIImage(named: "showers.png")
            bgWeatherImage.image = UIImage(named: "bgShower.jpg")
        } else if weatherDesc.contains("snow") {
            weatherImage.image = UIImage(named: "snow.png")
            bgWeatherImage.image = UIImage(named: "bgSnow.jpg")
        } else if weatherDesc.contains("thunderstorms") {
            weatherImage.image = UIImage(named: "thunderstorms.png")
            bgWeatherImage.image = UIImage(named: "bgThunder.jpg")
        } else if weatherDesc.contains("windy") {
            weatherImage.image = UIImage(named: "windy.png")
            bgWeatherImage.image = UIImage(named: "bgWindy.jpg")
        }
    }
}

extension StringProtocol {
    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
    }
}

extension WeatherController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let forecast = input.customWeatherModel.dailyForecast
        if forecast.isEmpty {
            return 0
        }
        return forecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let forecast = input.customWeatherModel.dailyForecast
        let daily = forecast[indexPath.row]
        if let cell = forecast5DayTableView.dequeueReusableCell(withIdentifier: "CustomForecastCell", for: indexPath) as? CustomForecastCell {
            cell.backgroundColor = .clear
            let date = Date(timeIntervalSince1970: TimeInterval(daily.date)).formatted(date: .complete, time: .shortened)
            if let dateString = date.components(separatedBy: ",").first {
                cell.dayOfWeek.text = "\(dateString)"
                cell.dayTemp.text = String(daily.dayTemp)
                cell.nightTemp.text = String(daily.nightTemp)
                return cell
            }
        }
        return UITableViewCell()
        
    }
}
