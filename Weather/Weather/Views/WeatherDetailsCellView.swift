//
//  WeatherDetailsCellView.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 13.11.2022.
//

import SwiftUI

enum WeatherDetailsType {
    case wind, humidity, feelsLike, sunrise
    
    var title: Text {
        switch self {
        case .wind:
            return Text("Wind".uppercased())
        case .humidity:
            return Text("Humidity".uppercased())
        case .feelsLike:
            return Text("Feels like".uppercased())
        case .sunrise:
            return Text("Sunrise".uppercased())
        }
    }
    
    var icon: Image {
        switch self {
        case .wind:
            return Image(systemName: "wind")
        case .humidity:
            return Image(systemName: "humidity")
        case .feelsLike:
            return Image(systemName: "thermometer.medium")
        case .sunrise:
            return Image(systemName: "sunrise.fill")
        }
    }
}

struct WeatherDetailsCellView: View {
    
    @State var detailsType: WeatherDetailsType
    @State var addInfo: String?
    @Binding var weatherData: String?
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    detailsType.icon
                    detailsType.title
                        .font(.customFont(weight: .regular, size: 14))
                    Spacer()
                }
                .opacity(0.55)
                Text(weatherData ?? "")
                    .foregroundColor(.white)
                Spacer()
            }
            .foregroundColor(.white)
            .padding()
        }
        .frame(width: UIScreen.screenWidth * 0.45, height: UIScreen.screenWidth * 0.45)
    }
}


struct WeatherDetailsCellView_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            Color.gray
            WeatherDetailsCellView(
                detailsType: .feelsLike,
                weatherData: .constant("ad"))
        }
    }
}
