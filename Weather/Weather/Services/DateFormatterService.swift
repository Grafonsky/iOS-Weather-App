//
//  DateFormatterService.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 30.10.2022.
//

import Foundation

enum DateType {
    case hour, sunMove, weekDay
    
    var dateFormat: String {
        switch self {
        case .hour:
            return "H"
        case .sunMove:
            return "H:mm"
        case .weekDay:
            return "EEEE"
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
    
}
