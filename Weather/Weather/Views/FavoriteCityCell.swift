//
//  FavoriteCityCell.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 20.12.22.
//

import SwiftUI

struct FavoriteCityCell: View {
    
    @State var title: String
    @State var subtitle: String
    @State var weatherDescription: String
    @State var currentTemp: Int
    @State var minMaxTemp: String
    @State var isCurrentLocation: Bool
    @State var icon: String
    
    var body: some View {
        
        ZStack {
            
            // FIXIT: - Temporarily hid background until i optimise this view
            
            //            let topBackgroundGradient = WeatherGradientModel().colors[icon]?[0] ?? ""
            //            let bottomBackgroundGradient = WeatherGradientModel().colors[icon]?[1] ?? ""
            //            let spriteKitNodes = SpriteKitNodes().nodes[icon] ?? []
            //
            //            BackgroundView(
            //                topBackgroundGradient: .constant(topBackgroundGradient),
            //                bottomBackgroundGradient: .constant(bottomBackgroundGradient),
            //                spriteKitNodes: .constant(spriteKitNodes),
            //                sceneState: .preview)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(isCurrentLocation ? "myLocation".localizable : title)
                        .font(.customFont(weight: .heavy, size: 28))
                        .foregroundColor(.white)
                    Text(isCurrentLocation ? title : subtitle)
                        .font(.customFont(weight: .bold, size: 15))
                        .foregroundColor(.white)
                        .opacity(0.6)
                    Spacer()
                    Text(weatherDescription)
                        .font(.customFont(weight: .bold, size: 15))
                        .foregroundColor(.white)
                        .opacity(0.6)
                }
                Spacer()
                VStack {
                    Text("\(currentTemp)°")
                        .font(.customFont(weight: .regular, size: 52))
                        .foregroundColor(.white)
                    Spacer()
                    HStack {
                        Text(minMaxTemp)
                            .font(.customFont(weight: .bold, size: 15))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
        }
        .frame(
            width: UIScreen.screenWidth * 0.9,
            height: 120)
        .cornerRadius(25)
    }
}

struct FavoriteCityCell_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.gray)
            FavoriteCityCell(
                title: "My Location",
                subtitle: "Tbilisi",
                weatherDescription: "Cloudy",
                currentTemp: 5,
                minMaxTemp: "H:7° L:3°",
                isCurrentLocation: true,
                icon: "01n")
        }
    }
}
