//
//  DailyForecastView.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 30.10.2022.
//

import SwiftUI

struct DailyForecastView: View {
    
    typealias DailyForecast = (
        icon: String,
        date: String,
        minTemp: CGFloat,
        maxTemp: CGFloat,
        isCurrentDay: Bool)
    
    @Binding var daily: [DailyForecast]
    @Binding var minWeekTemp: CGFloat
    @Binding var maxWeekTemp: CGFloat
    @Binding var currentTemp: CGFloat
    
    var body: some View {
        ZStack {
            
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                
                VStack {
                    HStack(spacing: 5) {
                        Image(systemName: "calendar")
                        Text("10-DAY FORECAST")
                            .font(.customFont(weight: .regular, size: 14))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .opacity(0.55)
                    
                    Divider()
                    ForEach($daily, id: \.date) { item in
                        DailyCellView(
                            date: item.date,
                            icon: item.icon,
                            minTemp: item.minTemp,
                            maxTemp: item.maxTemp,
                            minWeekTemp: $minWeekTemp,
                            maxWeekTemp: $maxWeekTemp,
                            currentTemp: $currentTemp,
                            isCurrentDay: item.isCurrentDay)
                    }
                }
                .padding()
            }
        }
        .frame(width: UIScreen.screenWidth * 0.9)
    }
}

struct DailyForecastView_Previews: PreviewProvider {
    static var previews: some View {
        DailyForecastView(
            daily: .constant([
                (icon: "cloud.fill", date: "Fri", minTemp: .zero, maxTemp: .zero, isCurrentDay: true),
            ]),
            minWeekTemp: .constant(12),
            maxWeekTemp: .constant(24),
            currentTemp: .constant(14)
        )
    }
}
