//
//  ConnectionService.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 09.01.2022.
//

import Foundation
import Network

protocol ConnectionService {
    var isConnected: Bool { get set }
    var monitor: NWPathMonitor { get set }
    func checkIfInternetOn()
}
