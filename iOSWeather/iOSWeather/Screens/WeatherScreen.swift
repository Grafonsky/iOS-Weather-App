//
//  WeatherScreen.swift
//  iOSWeather
//
//  Created by Bohdan Hawrylyshyn on 8.10.2022.
//

import SwiftUI

struct WeatherScreen: View {
    
    var body: some View {
        ZStack {
            Color.gray
            
            VStack {
                WeatherView(cityName: "Montreal", currentTemp: "19°", weatherDescription: "Mostly clear", highestLowestTemp: "H:24° L:18°")
                Spacer()
            }
        }
    }
}






struct WeatherScreen_Previews: PreviewProvider {
    static var previews: some View {
        WeatherScreen()
    }
}
