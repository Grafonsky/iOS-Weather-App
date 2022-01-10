//
//  ConnectionServiceImp.swift
//  iOSWeatherApp
//
//  Created by Bohdan Hawrylyshyn on 09.01.2022.
//

import Foundation
import Network

final class ConnectionServiceImp: ConnectionService {
    var isConnected: Bool = false
    var monitor = NWPathMonitor()

    func checkIfInternetOn() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Connected")
            }
        }
    }
}
