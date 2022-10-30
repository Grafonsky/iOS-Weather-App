//
//  WeatherView.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 28.10.2022.
//

import SwiftUI

struct WeatherView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    
    @State var isWeatherExpand: Bool = true
    
    var body: some View {
        
        ZStack {
            Color.gray
                .ignoresSafeArea()
            
            ScrollView {
                if isWeatherExpand {
                    VStack(spacing: 0) {
                        Text(viewModel.cityName ?? "—")
                            .font(.customFont(weight: .medium, size: 34))
                        Text(viewModel.temp ?? "—")
                            .font(.customFont(weight: .medium, size: 100))
                        Text(viewModel.weatherDescription?.capitalizingFirstLetter() ?? "—")
                            .font(.customFont(weight: .medium, size: 22))
                        Text("H: \(viewModel.dailyForecast.first?.maxTemp ?? "—") L:\(viewModel.dailyForecast.first?.minTemp ?? "—")")
                            .font(.customFont(weight: .medium, size: 22))
                    }
                    .foregroundColor(.white)
                    .transition(.opacity)
                } else {
                    VStack {
                        Text(viewModel.cityName ?? "—")
                            .font(.customFont(weight: .medium, size: 34))
                        HStack {
                            Text(viewModel.temp ?? "—")
                            Text("|")
                            Text(viewModel.weatherDescription?.capitalizingFirstLetter() ?? "—")
                        }
                        .font(.customFont(weight: .medium, size: 18))
                    }
                    .foregroundColor(.white)
                    .transition(.opacity)
                }
                
                Button ("isWeatherExpand") {
                    withAnimation {
                        isWeatherExpand.toggle()
                    }
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
