//
//  DateFormatterService.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 23.01.2022.
//

import Foundation

protocol DateFormatterService {
    func dateToString(date: NSDate, format: String) -> String
    func dailyDateFormatter(date: Double) -> String
    func hourlyDateFormatter(date: Double) -> String
}
