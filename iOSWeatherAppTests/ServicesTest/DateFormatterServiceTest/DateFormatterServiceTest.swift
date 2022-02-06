//
//  DateFormatterServiceTest.swift
//  iOSWeatherAppTests
//
//  Created by Bohdan Hawrylyshyn on 07.02.2022.
//

import XCTest
@testable import iOSWeatherApp

class DateFormatterServiceTest: XCTestCase {
    
    let service = DateFormatterServiceImp()
    
    func testDateToString() {
        //arrange
        let date: NSDate = NSDate(timeIntervalSinceReferenceDate: 0)
        let format: String = "EEEE, MMM d, yyyy, HH:mm:ss"
        
        //act
        let dateToString = service.dateToString(date: date, format: format)
        
        //assert
        XCTAssertEqual(dateToString, "Monday, Jan 1, 2001, 03:00:00")
        
    }
    
    func testDailyDateFormatter() {
        //arrange
        let date: Double = 0
        
        //act
        let dateToString = service.dailyDateFormatter(date: date)
        
        //assert
        XCTAssertEqual(dateToString, "Thursday")
        
    }
    
    func testHourlyDateFormatter() {
        //arrange
        let date: Double = 90827258
        
        //act
        let dateToString = service.hourlyDateFormatter(date: date)
        
        //assert
        XCTAssertEqual(dateToString, "08:47")
        
    }
    
}
