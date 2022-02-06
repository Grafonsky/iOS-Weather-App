//
//  WeatherServiceTest.swift
//  iOSWeatherAppTests
//
//  Created by Bohdan Hawrylyshyn on 31.01.2022.
//

import XCTest
@testable import iOSWeatherApp
import CoreLocation

class WeatherServiceTest: XCTestCase {
    
    let service = WeatherServiceImp()
    
    func testLoadWeatherData() {
        //arrange
        let lat: CLLocationDegrees = 48.7113982
        let lon: CLLocationDegrees = 44.5140051
        let exp = expectation(description: "\(#function)\(#line)")
        
        //act
        service.loadWeatherData(lat: lat, lon: lon) { jsonData in
            exp.fulfill()
        }
        
        //assert
        waitForExpectations(timeout: 10, handler: nil)
        
    }
}
