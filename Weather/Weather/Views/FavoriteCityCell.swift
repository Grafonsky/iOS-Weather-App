//
//  FavoriteCityCell.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 20.12.22.
//

import SwiftUI

struct FavoriteCityCell: View {
    
    @State var title: String
    @State var subtitle: String
    @State var weatherDescription: String
    @State var currentTemp: Int
    @State var minMaxTemp: String
    @State var isCurrentLocation: Bool
    @State var icon: String
    @State var windSpeed: String
    @State var timezoneOffset: Int
    
    var body: some View {
        
        ZStack {
            let backgroundStyleCase = BackgroundStyleModel(rawValue: icon)
            let cloudThickness: Cloud.Thickness = backgroundStyleCase?.cloudThickness ?? .none
            let isRainOn = backgroundStyleCase?.isRainOn ?? false
            let isSnowOn = backgroundStyleCase?.isSnowOn ?? false
            let isThunderstormOn = backgroundStyleCase?.isThunderstormOn ?? false
            let rainCase = RainIntensity(rawValue: weatherDescription)
            let snowCase = SnowIntensity(rawValue: weatherDescription)
            let rainIntensity = rainCase?.intensity ?? 0
            let snowIntensity = snowCase?.intensity ?? 0
            let precipitationAngle = WindAngle.current(speed: windSpeed).angle
            
            BackgroundView(
                cloudThickness: .constant(cloudThickness),
                isRainOn: .constant(isRainOn),
                isSnowOn: .constant(isSnowOn),
                isThunderstormOn: .constant(isThunderstormOn),
                snowIntensity: .constant(snowIntensity),
                rainIntensity: .constant(rainIntensity),
                time: .constant(DateFormatterService.shared.dateForBackground(
                    timezoneOffset: timezoneOffset,
                    dateType: .sunMove)),
                precipitationAngle: .constant(precipitationAngle))
            
            HStack {
                VStack(alignment: .leading) {
                    Text(isCurrentLocation ? "myLocation".localizable : title)
                        .font(.customFont(weight: .heavy, size: 28))
                        .foregroundColor(.white)
                    Text(isCurrentLocation ? title : subtitle)
                        .font(.customFont(weight: .bold, size: 15))
                        .foregroundColor(.white)
                        .opacity(0.6)
                    Spacer()
                    Text(weatherDescription)
                        .font(.customFont(weight: .bold, size: 15))
                        .foregroundColor(.white)
                        .opacity(0.6)
                }
                Spacer()
                VStack {
                    Text("\(currentTemp)°")
                        .font(.customFont(weight: .regular, size: 52))
                        .foregroundColor(.white)
                    Spacer()
                    HStack {
                        Text(minMaxTemp)
                            .font(.customFont(weight: .bold, size: 15))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
        }
        .frame(
            width: UIScreen.screenWidth * 0.9,
            height: 120)
        .cornerRadius(25)
    }
}

struct FavoriteCityCell_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.gray)
            FavoriteCityCell(
                title: "My Location",
                subtitle: "Tbilisi",
                weatherDescription: "Cloudy",
                currentTemp: 5,
                minMaxTemp: "H:7° L:3°",
                isCurrentLocation: true,
                icon: "01n",
                windSpeed: "1.25",
                timezoneOffset: 7200)
        }
    }
}
