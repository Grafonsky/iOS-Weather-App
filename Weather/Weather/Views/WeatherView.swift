//
//  WeatherView.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 28.10.2022.
//

import SwiftUI

struct WeatherView: View {
    
    @State var locator: LocationService
    
    init(locator: LocationService) {
        self.locator = locator
    }
    
    var body: some View {
        VStack {
            Text("123")
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(locator: .init())
    }
}
