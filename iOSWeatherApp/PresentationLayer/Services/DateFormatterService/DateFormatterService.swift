//
//  DateFormatterService.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 23.01.2022.
//

import Foundation

protocol DateFormatterService {
    func dailyDateFormatter(date: Double) -> String
    func hourlyDateFormatter(date: Double) -> String

}
