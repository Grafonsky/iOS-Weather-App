//
//  DateFormatterService.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 30.10.2022.
//

import Foundation

enum DateType {
    case hour, sunMove, weekDay, comparisonHours
    
    var dateFormat: String {
        switch self {
        case .hour:
            return "H"
        case .sunMove:
            return "H:mm"
        case .weekDay:
            return "EEEE"
        case .comparisonHours:
            return "HH"
        }
    }
}

final class DateFormatterService {
    
    static var shared = DateFormatterService()
    
    private let dateFormatter = DateFormatter()
    
    func dateToString(time: Int, timezoneOffset: Int, dateType: DateType) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(time))
        dateFormatter.dateFormat = dateType.dateFormat
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
    
    func dateForBackground(timezoneOffset: Int, dateType: DateType) -> Double {
        dateFormatter.dateFormat = dateType.dateFormat
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        
        var hours = 0.0
        var minutes = 0.0
        
        let time = Date.currentTimeStamp
        let date = Date(timeIntervalSince1970: TimeInterval(time))
        let dateArr = dateFormatter.string(from: date).components(separatedBy: ":")
        
        hours = Double(dateArr.first ?? "0.0") ?? 0.0
        minutes = Double(dateArr.last ?? "0.0") ?? 0.0
        
        let hoursToMinutes = hours * 60
        let timeValue = (hoursToMinutes + minutes) / 1440
        
        return timeValue
    }
}
