//
//  BackgroundServiceTest.swift
//  iOSWeatherAppTests
//
//  Created by Bohdan Hawrylyshyn on 07.02.2022.
//

import XCTest
@testable import iOSWeatherApp

class BackgroundServiceTest: XCTestCase {
    
    let service = BackgroundServiceImp()
    var weatherEntity = WeatherCustomEntity.init(city: "", lat: 0, lon: 0, currentTemp: 0, minTemp: 0, maxTemp: 0, alert: [], desc: "", feelsLike: 0, humidity: 0, windSpeed: 0, sunrise: 0, sunset: 0, hourlyForecast: [], dailyForecast: [], icon: "")
    var locationModel = LocationModel.init(cityName: "", lat: 0, lon: 0, subTitle: "", weatherDesc: "", temp: 0, minTemp: 0, maxTemp: 0, icon: "")
    
    func testBackgroundGradient() {
        //arrange
        weatherEntity.icon = "13d"
        
        //act
        let gradient = service.backgroundGradient(entity: weatherEntity)
        
        //assert
        XCTAssertEqual(gradient, ["#6d7992", "#454d5f"])
        
    }
    
    func testBackgroundAnimations() {
        //arrange
        weatherEntity.icon = "13n"
        
        //act
        let animations = service.backgroundAnimations(entity: weatherEntity)
        
        //assert
        XCTAssertEqual(animations, ["Stars", "Snow", "Clouds"])
        
    }
    
    func testSearchResultsGradient() {
        //arrange
        locationModel.icon = "01n"
        
        //act
        let gradient = service.searchResultsGradient(entity: locationModel)
        
        //assert
        XCTAssertEqual(gradient, ["#22282c", "#161a1c"])
    }
    
    func testSearchResultsAnimations() {
        //arrange
        weatherEntity.icon = "50n"
        
        //act
        let animations = service.backgroundAnimations(entity: weatherEntity)
        
        //assert
        XCTAssertEqual(animations, ["Stars", "Fog", "Clouds"])
        
    }
    
}
