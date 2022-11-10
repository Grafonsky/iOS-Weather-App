//
//  DailyCellView.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 10.11.2022.
//

import SwiftUI

struct DailyCellView: View {
    
    @Binding var date: String
    @Binding var icon: String
    @Binding var minTemp: CGFloat
    @Binding var maxTemp: CGFloat
    @Binding var minWeekTemp: CGFloat
    @Binding var maxWeekTemp: CGFloat
    @Binding var currentTemp: CGFloat
    @Binding var isCurrentDay: Bool
    
    var body: some View {
        
        let screenWidth: CGFloat = UIScreen.screenWidth * 0.2
        let unitWidth: CGFloat = abs(screenWidth / (maxWeekTemp - minWeekTemp))
        let weatherRangeWidth: CGFloat = unitWidth * (maxTemp - minTemp)
        let offset: CGFloat = ((maxWeekTemp - maxTemp) + (minWeekTemp - minTemp)) / 2
        let currentTempOffset: CGFloat = ((maxWeekTemp - maxTemp) + (minWeekTemp - minTemp) + (minTemp - currentTemp) + (maxTemp - currentTemp)) / 2
        
        ZStack {
            HStack {
                Text(date)
                    .font(.customFont(weight: .medium, size: 17))
                Spacer()
                HStack(spacing: 10) {
                    Text("\(Int(minTemp))°")
                        .font(.customFont(weight: .medium, size: 17))
                    ZStack {
                        Rectangle()
                            .opacity(0.15)
                            .foregroundColor(.black)
                            .frame(height: 5)
                            .overlay {
                                LinearGradient(
                                    gradient: Gradient(
                                        colors: [
                                            Color.getWeatherColor(temp: minTemp),
                                            Color.getWeatherColor(temp: maxTemp)]),
                                    startPoint: .leading,
                                    endPoint: .trailing)
                                .cornerRadius(2.5)
                                .frame(width: weatherRangeWidth)
                                .offset(x: -offset * unitWidth)
                                .frame(height: 5)
                            }
                            .reverseMask {
                                if isCurrentDay {
                                    Circle()
                                        .frame(width: 10, height: 10)
                                        .offset(x: -currentTempOffset * unitWidth)
                                }
                            }
                            .cornerRadius(2.5)
                        if isCurrentDay {
                            Circle()
                                .frame(width: 5, height: 5)
                                .offset(x: -currentTempOffset * unitWidth)
                        }
                    }
                    .frame(width: UIScreen.screenWidth * 0.2, height: 5)
                    Text("\(Int(maxTemp))°")
                        .font(.customFont(weight: .medium, size: 17))
                }
            }
            Image(systemName: icon)
                .offset(x: -15)
        }
        .foregroundColor(.white)
    }
}

struct DailyCellView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray
            DailyCellView(
                date: .constant("Fri"),
                icon: .constant("cloud.fill"),
                minTemp: .constant(16),
                maxTemp: .constant(41),
                minWeekTemp: .constant(11),
                maxWeekTemp: .constant(45),
                currentTemp: .constant(41),
                isCurrentDay: .constant(true))
        }
    }
}
