//
//  DetailsCellView.swift
//  iOSWeather
//
//  Created by Bohdan Hawrylyshyn on 9.10.2022.
//

import SwiftUI

enum DetailsType {
    case feelsLike, humidity, visibility, precipitation
    
    var name: String {
        switch self {
        case .feelsLike:
            return "feelsLike".localizable
        case .humidity:
            return "humidity".localizable
        case .visibility:
            return "visibility".localizable
        case .precipitation:
            return "Precipitation".localizable
        }
    }
    
    var iconName: String {
        switch self {
        case .feelsLike:
            return "thermometer.medium"
        case .humidity:
            return "humidity.fill"
        case .visibility:
            return "eye.fill"
        case .precipitation:
            return "drop.fill"
        }
    }
}

struct DetailsCellView: View {
    
    @State var detailsType: DetailsType
    
    var sideSize = (UIScreen.screenWidth - 30 * 2 - 14) / 2
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .opacity(0.6)
            
            VStack {
                HStack {
                    Image(systemName: detailsType.iconName)
                    Text(detailsType.name)
                        .textCase(.uppercase)
                        .font(.customFont(weight: .semibold, size: 14))
                    Spacer()
                }
                .foregroundColor(.white)
                .opacity(0.6)
                .padding(.leading, 12)
                .padding(.top, 15)
                
                
                HStack {
                    Text("19°")
                        .font(.customFont(weight: .medium, size: 40))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.leading, 12)
                
                Spacer()
                
                HStack {
                    Text("Additional info")
                        .font(.customFont(weight: .regular, size: 12))
                        .lineLimit(3)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.leading, 12)
                .padding(.bottom, 15)

            }
        }
        .frame(
            width: sideSize,
            height: sideSize
        )
        .cornerRadius(22)
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.init(hex: "495093"), lineWidth: 2))
    }
}

struct DetailsCellView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsCellView(detailsType: .precipitation)
            .previewLayout(.sizeThatFits)
    }
}
