//
//  HourlyForecastView.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 30.10.2022.
//

import SwiftUI

struct HourlyForecastView: View {
    
    typealias HourlyForecast = (icon: String, date: String, temp: String)
    
    @Binding var hourly: [HourlyForecast]
    @Binding var alert: String?
    @Binding var precipitationType: Storm.Contents
    @Binding var residueStrength: Double
    
    var body: some View {
        
        VStack(spacing: 0) {
            ResidueView(type: precipitationType, strength: residueStrength)
                .offset(y: 5)
                .zIndex(1)
            
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                VStack {
                    if alert != nil {
                        HStack {
                            Text(alert ?? "—")
                                .font(.customFont(weight: .regular, size: 14))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        Divider()
                    }
                    HStack(alignment: .center) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach($hourly, id: \.date) { item in
                                    HourlyCellView(
                                        hour: item.date,
                                        icon: item.icon,
                                        temp: item.temp)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .frame(width: UIScreen.screenWidth * 0.9)
        }
    }
}
