//
//  WeatherView.swift
//  iOSWeather
//
//  Created by Bohdan Hawrylyshyn on 9.10.2022.
//

import SwiftUI

struct WeatherView: View {
    
    @State var cityName: String
    @State var currentTemp: String
    @State var weatherDescription: String
    @State var highestLowestTemp: String
    
    init(cityName: String, currentTemp: String, weatherDescription: String, highestLowestTemp: String) {
        self.cityName = cityName
        self.currentTemp = currentTemp
        self.weatherDescription = weatherDescription
        self.highestLowestTemp = highestLowestTemp
    }
    
    var body: some View {
        
        VStack (spacing: 12) {
            Text(cityName)
                .font(.customFont(weight: .regular, size: 34))
            Text(currentTemp)
                .font(.customFont(weight: .thin, size: 96))
            VStack (spacing: 0) {
                Text(weatherDescription)
                    .foregroundColor(.init(hex: "a1a1a8"))
                Text(highestLowestTemp)
            }
            .font(.customFont(weight: .semibold, size: 20))
        }
        .foregroundColor(.white)
        
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(cityName: "Montreal", currentTemp: "19°", weatherDescription: "Mostly clear", highestLowestTemp: "H:24° L:18°")
            .previewLayout(.sizeThatFits)
    }
}
