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
    
    var body: some View {
        
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

struct HourlyForecastView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyForecastView(
            hourly: .constant([
                (icon: "sun.max.fill", date: "Now", temp: "1°"),
                (icon: "sun.max.fill", date: "22", temp: "1°"),
                (icon: "sun.max.fill", date: "23", temp: "1°"),
                (icon: "sun.max.fill", date: "00", temp: "1°"),
                (icon: "sun.max.fill", date: "01", temp: "1°"),
                (icon: "sun.max.fill", date: "02", temp: "1°"),
                (icon: "sun.max.fill", date: "03", temp: "1°"),
            ]),
            alert: .constant("Ветер местами порывы 15-20 from 21:00 to 10:00"))
    }
}
