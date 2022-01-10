//
//  WeatherPresenterImp.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 08.01.2022.
//

import Foundation
import UIKit
import Network

final class WeatherPresenterImp: WeatherPresenterInput {
    weak var outputWeatherPresenter: WeatherPresenterOutput?
    var inputSetCityPresenter: SetCityPresenterInput?
    
    var locationService: LocationService = LocationServiceImp()
    var storageService: StorageService = StorageServiceImp()
    var connectionService: ConnectionService = ConnectionServiceImp()
    
    var customWeatherModel: CustomWeatherModel = CustomWeatherModel.shared
    var rawWeatherModel: RawWeatherModel = RawWeatherModel.init(lat: 0, lon: 0, current: Current.init(temp: 0,feels_like: 0,humidity: 0,wind_speed: 0,weather: [Weather.init(main: "",description: "")]),daily: [Daily.init(dt: 0,temp: Temp.init(day: 0,night: 0))])
    
    var lat: Double = 9999
    var lon: Double = 9999
    var geoByUser: Bool = false
    var timer: Timer?

    func viewIsReady() {
        startMonitoringConnection()
        updateWeather()
        startTimer ()
    }
    
    func startTimer () {
      guard timer == nil else { return }
        timer =  Timer.scheduledTimer(
          timeInterval: TimeInterval(2),
          target      : self,
          selector    : #selector(loadOldModelByTimer),
          userInfo    : nil,
          repeats     : true)
    }
    
    @objc private func loadOldModelByTimer() {
        guard let unwrapOldModel = storageService.downloadData() else { return }
        customWeatherModel = unwrapOldModel
        DispatchQueue.main.async {
            self.outputWeatherPresenter?.setDataToUI()
        }
    }
    
    func updateWeather() {
        loadOldModelByTimer()
        DispatchQueue.global(qos: .userInteractive).sync {
            if !geoByUser {
                updateByApiGeo()
            } else {
                updateByUsersGeo()
            }
        }
        print(customWeatherModel.temp)

    }

     private func updateByApiGeo() {
        detectLocation()
        locationService.getCityName(lat: lat, lon: lon)
        getWeatherData(lat: lat, lon: lon)
    }
    
    private func updateByUsersGeo() {
        locationService.getCityName(lat: lat, lon: lon)
        getWeatherData(lat: lat, lon: lon)
    }
    
    private func checkConnection() -> Bool {
        connectionService.monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.connectionService.isConnected = true
            } else {
                self.connectionService.isConnected = false
            }
        }
        return self.connectionService.isConnected
        
    }
    
    private func startMonitoringConnection() {
        let queue = DispatchQueue.global(qos: .background)
        connectionService.monitor.start(queue: queue)
    }
    
    private func stopMonitoringConnection() {
        connectionService.monitor.cancel()
    }
    
    func getWeatherData(lat: Double, lon: Double) {
        let session: URLSession = URLSession.shared
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=alerts&appid=\(Constants.OWAPI)") else {
            return
        }
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, response, error in
            self.parseWeatherData(data: data as NSData?, response: response as URLResponse?, error: error as NSError?)
        }
        task.resume()
    }
    
    private func parseWeatherData(data: NSData?, response: URLResponse?, error: NSError?) {
        if error == nil && data != nil {
            let decoder = JSONDecoder()
            guard let unwrapData = data else { return }
            if let jsonData = try? decoder.decode(RawWeatherModel.self, from: unwrapData as Data) {
                rawWeatherModel = jsonData
                saveToCustomModel(data: rawWeatherModel)
                DispatchQueue.main.sync {
                    outputWeatherPresenter?.setDataToUI()
                }
                storageService.uploadData(data: customWeatherModel)
            }
        }
    }
    
    func saveToCustomModel(data: RawWeatherModel) {
        let city: String = locationService.city
        let temp: Double = rawWeatherModel.current.temp
        let desc: String = rawWeatherModel.current.weather[0].description
        let feelsLike: Double = rawWeatherModel.current.feels_like
        let humidity: Double = rawWeatherModel.current.humidity
        let windSpeed: Double = rawWeatherModel.current.wind_speed
        var dailyForecast: [CustomDailyWeatherModel] = []
        rawWeatherModel.daily.flatMap {
            dailyForecast.append(
                CustomDailyWeatherModel.init(
                    date: $0.dt,
                    dayTemp: $0.temp.day,
                    nightTemp: $0.temp.night))}
        customWeatherModel.setCity(city: city)
        customWeatherModel.setTemp(temp: temp)
        customWeatherModel.setDesc(desc: desc)
        customWeatherModel.setFeelsLike(feelsLike: feelsLike)
        customWeatherModel.setHumidity(humidity: humidity)
        customWeatherModel.setWindSpeed(windSpeed: windSpeed)
        customWeatherModel.setDailyForecast(dailyForecast: dailyForecast)
    }
    
    func detectLocation() {
        let location = locationService.getUserPosition()
        guard let unwrapLat = location?.latitude else { return }
        guard let unwrapLon = location?.longitude else { return }
        lat = unwrapLat
        lon = unwrapLon
    }
}
