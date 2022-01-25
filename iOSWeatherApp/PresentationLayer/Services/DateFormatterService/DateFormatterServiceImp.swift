//
//  DateFormatterServiceImp.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 23.01.2022.
//

import Foundation

final class DateFormatterServiceImp: DateFormatterService {
    
    // MARK: - Protocols funcs
    
    func dailyDateFormatter(date: Double) -> String {
        let givenDate = dateToString(date: NSDate(timeIntervalSince1970: TimeInterval(date)), format: "EEEE")
        let currentDate = dateToString(date: NSDate.now as NSDate, format: "EEEE")
        if givenDate != currentDate {
            return givenDate
        }
        return "Today"
    }
    
    // MARK: - Private funcs
    
    private func dateToString(date: NSDate, format: String) -> String {
        let dateFormatter = DateFormatter()
        let givenDate = dateFormatter.string(from: date as Date)
        dateFormatter.dateFormat = format
        let string = dateFormatter.string(from: date as Date)
        return string

    }
    
}
