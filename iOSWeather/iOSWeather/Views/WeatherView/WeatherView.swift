//
//  WeatherView.swift
//  iOSWeather
//
//  Created by Bohdan Hawrylyshyn on 11.10.2022.
//

import SwiftUI

struct WeatherView: View {
    var body: some View {
        ZStack {
            Color.red
            Text("WeatherView")
        }
        .ignoresSafeArea()
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
