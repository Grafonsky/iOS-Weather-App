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
            let backgroundStyleCase = BackgroundStyleModel(rawValue: $viewModel.icon.wrappedValue ?? "")
            let cloudThickness: Cloud.Thickness = backgroundStyleCase?.cloudThickness ?? .none
            let weatherDescription = $viewModel.weatherDescription.wrappedValue ?? ""
            let isRainOn = backgroundStyleCase?.isRainOn ?? false
            let isSnowOn = backgroundStyleCase?.isSnowOn ?? false
            let isThunderstormOn = backgroundStyleCase?.isThunderstormOn ?? false
            let rainCase = RainIntensity(rawValue: weatherDescription)
            let snowCase = SnowIntensity(rawValue: weatherDescription)
            let rainIntensity = rainCase?.intensity ?? 0
            let snowIntensity = snowCase?.intensity ?? 0
            let precipitationAngle = WindAngle.current(speed: $viewModel.windSpeed.wrappedValue ?? "").angle
            
            BackgroundView(
                cloudThickness: .constant(cloudThickness),
                isRainOn: .constant(isRainOn),
                isSnowOn: .constant(isSnowOn),
                isThunderstormOn: .constant(isThunderstormOn),
                snowIntensity: .constant(snowIntensity),
                rainIntensity: .constant(rainIntensity),
                time: .constant(DateFormatterService.shared.dateForBackground(
                    timezoneOffset: $viewModel.timeOffset.wrappedValue,
                    dateType: .sunMove)),
                precipitationAngle: .constant(precipitationAngle))
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    if $viewModel.networkStatus.wrappedValue != .satisfied {
                        NoInternetView()
                    }
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
                                $viewModel.maxTemp.wrappedValue ?? "—",
                                $viewModel.minTemp.wrappedValue ?? "—"))
                    .font(.customFont(weight: .medium, size: 22))
                    .shadow(color: Color.black.opacity(0.4), radius: 5)
                }
                .foregroundColor(.white)
                .transition(.opacity)
                
                VStack(spacing: 10) {
                    if isSnowOn {
                        HourlyForecastView(
                            hourly: $viewModel.hourlyForecast,
                            alert: $viewModel.alert,
                            precipitationType: .constant(.snow),
                            residueStrength: .constant(Double(snowIntensity)))
                    } else if isRainOn {
                        HourlyForecastView(
                            hourly: $viewModel.hourlyForecast,
                            alert: $viewModel.alert,
                            precipitationType: .constant(.rain),
                            residueStrength: .constant(Double(rainIntensity)))
                    } else {
                        HourlyForecastView(
                            hourly: $viewModel.hourlyForecast,
                            alert: $viewModel.alert,
                            precipitationType: .constant(.none),
                            residueStrength: .constant(0))
                    }
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
                            weatherData: .constant("\($viewModel.windSpeed.wrappedValue ?? "0.0") km/h"))
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
        WeatherView(
            viewModel: .init(
                weatherType: .current,
                locationService: .init()))
    }
}
