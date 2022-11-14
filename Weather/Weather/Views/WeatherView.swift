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
        
        let minTemp = $viewModel.dailyForecast.first?.minTemp.wrappedValue ?? 0
        let maxTemp = $viewModel.dailyForecast.first?.maxTemp.wrappedValue ?? 0
        
        ZStack {
            
            BackgroundView(
                topBackgroundGradient: $viewModel.topBackgroundColor,
                bottomBackgroundGradient: $viewModel.bottomBackgroundColor,
                spriteKitNodes: $viewModel.spriteKitNodes)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Text(viewModel.cityName ?? "—")
                        .font(.customFont(weight: .medium, size: 34))
                    Text(viewModel.temp ?? "—")
                        .font(.customFont(weight: .medium, size: 100))
                    Text(viewModel.weatherDescription?.capitalizingFirstLetter() ?? "—")
                        .font(.customFont(weight: .medium, size: 22))
                    Text("H: \(Int(minTemp))° L: \(Int(maxTemp))°")
                        .font(.customFont(weight: .medium, size: 22))
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
                            weatherData: $viewModel.feelsLike)
                        WeatherDetailsCellView(
                            detailsType: .humidity,
                            weatherData: $viewModel.humidity)
                    }
                    
                    HStack {
                        WeatherDetailsCellView(
                            detailsType: .wind,
                            weatherData: $viewModel.windSpeed)
                        WeatherDetailsCellView(
                            detailsType: .sunrise,
                            weatherData: $viewModel.sunrise)
                    }
                }
                Spacer()
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: .init())
    }
}
