//
//  WeatherView.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 28.10.2022.
//

import SwiftUI

struct WeatherView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        
        ZStack {
            
            BackgroundView(
                topBackgroundGradient: $viewModel.topBackgroundColor,
                bottomBackgroundGradient: $viewModel.bottomBackgroundColor,
                spriteKitNodes: $viewModel.spriteKitNodes)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Text(viewModel.cityName ?? "—")
                        .font(.customFont(weight: .medium, size: 34))
                        .shadow(color: Color.black.opacity(0.35), radius: 5)
                    Text(viewModel.temp ?? "—")
                        .font(.customFont(weight: .medium, size: 100))
                        .shadow(color: Color.black.opacity(0.25), radius: 5)
                    Text(viewModel.weatherDescription?.capitalizingFirstLetter() ?? "—")
                        .font(.customFont(weight: .medium, size: 22))
                        .shadow(color: Color.black.opacity(0.4), radius: 5)
                    Text(String(format: NSLocalizedString(
                        "highestLowestTemps", comment: ""),
                                $viewModel.maxTemp.wrappedValue ?? "",
                                $viewModel.minTemp.wrappedValue ?? ""))
                    .font(.customFont(weight: .medium, size: 22))
                    .shadow(color: Color.black.opacity(0.4), radius: 5)
                }
                .foregroundColor(.white)
                .transition(.opacity)
                
                VStack(spacing: 10) {
                    HourlyForecastView(
                        hourly: $viewModel.hourlyForecast,
                        alert: $viewModel.alert)
                    
                    DailyForecastView(
                        daily: $viewModel.dailyForecast,
                        minWeekTemp: $viewModel.minWeekTemp,
                        maxWeekTemp: $viewModel.maxWeekTemp,
                        currentTemp: $viewModel.currentTemp)
                }
                
                VStack {
                    HStack {
                        WeatherDetailsCellView(
                            detailsType: .feelsLike,
                            addInfo: viewModel.isFeelsLikeCoolerTemp ? .constant("isFeelsLikeCoolerTemp") : .constant(nil),
                            weatherData: $viewModel.feelsLike)
                        WeatherDetailsCellView(
                            detailsType: .humidity,
                            addInfo: .constant(nil),
                            weatherData: $viewModel.humidity)
                    }
                    
                    HStack {
                        WeatherDetailsCellView(
                            detailsType: .wind,
                            addInfo: .constant(nil),
                            weatherData: $viewModel.windSpeed)
                        WeatherDetailsCellView(
                            detailsType: viewModel.isAMtime ? .sunrise : .sunset,
                            addInfo: viewModel.isAMtime ? $viewModel.sunset : $viewModel.sunrise,
                            weatherData: viewModel.isAMtime ? $viewModel.sunrise : $viewModel.sunset)
                    }
                }
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: .init())
    }
}
