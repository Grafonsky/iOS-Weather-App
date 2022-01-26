//
//  DateFormatterServiceImp.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 23.01.2022.
//

import Foundation

final class DateFormatterServiceImp: DateFormatterService {
    
    // MARK: - Protocols funcs
    
    func dateToString(date: NSDate, format: String) -> String {
        let dateFormatter = DateFormatter()
        let givenDate = dateFormatter.string(from: date as Date)
        dateFormatter.dateFormat = format
        let string = dateFormatter.string(from: date as Date)
        return string
    }
    
    func dailyDateFormatter(date: Double) -> String {
        let format = "EEEE"
        let givenDate = dateToString(date: NSDate(timeIntervalSince1970: TimeInterval(date)), format: format)
        let currentDate = dateToString(date: NSDate.now as NSDate, format: format)
        if givenDate != currentDate {
            return givenDate
        }
        return "Today"
    }
    
    func hourlyDateFormatter(date: Double) -> String {
        let format = "HH:mm"
        let givenDate = dateToString(date: NSDate(timeIntervalSince1970: TimeInterval(date)), format: format)
        let currentDate = dateToString(date: NSDate.now as NSDate, format: format)
        if givenDate.components(separatedBy: ":")[0] != currentDate.components(separatedBy: ":")[0] {
            return givenDate
        }
        
        return "Now"
    }
 
}
