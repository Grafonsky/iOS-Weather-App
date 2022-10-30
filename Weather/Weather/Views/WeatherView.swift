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
        VStack {
            ScrollView {
                Group {
                    Text(viewModel.cityName ?? "—")
                    Text(viewModel.temp ?? "—")
                    Text(viewModel.windSpeed ?? "—")
                    Text(viewModel.humidity ?? "—")
                    Text(viewModel.weatherDescription ?? "—")
                    Text(viewModel.icon ?? "—")
                    Text(viewModel.sunrise ?? "—")
                    Text(viewModel.sunset ?? "—")
                    Text(viewModel.feelsLike ?? "—")
                }
                
                ForEach(viewModel.hourlyForecast,  id: \.date) { item in
                    Text(item.icon)
                    Text(item.date)
                    Text(item.temp)
                }
                
                ForEach(viewModel.dailyForecast,  id: \.date) { item in
                    Text(item.icon)
                    Text(item.date)
                    Text(item.minTemp)
                    Text(item.maxTemp)
                }
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(viewModel: .init())
    }
}
