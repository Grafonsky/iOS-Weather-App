//
//  BackgroundView.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 13.11.2022.
//

import SwiftUI

struct BackgroundView: View {
    
    @Binding var cloudThickness: Cloud.Thickness
    @Binding var isRainOn: Bool
    @Binding var isSnowOn: Bool
    @Binding var isThunderstormOn: Bool
    @Binding var snowIntensity: Int
    @Binding var rainIntensity: Int
    @Binding var time: Double
    @Binding var precipitationAngle: Double
    
    @State private var lightningMaxBolts = 4.0
    @State private var lightningForkProbability = 20.0
    @State private var stormType = Storm.Contents.rain
    
    let backgroundTopStops: [Gradient.Stop] = [
        .init(color: .midnightStart, location: 0),
        .init(color: .midnightStart, location: 0.25),
        .init(color: .sunriseStart, location: 0.33),
        .init(color: .sunnyDayStart, location: 0.38),
        .init(color: .sunnyDayStart, location: 0.7),
        .init(color: .sunsetStart, location: 0.78),
        .init(color: .midnightStart, location: 0.82),
        .init(color: .midnightStart, location: 1)
    ]
    
    let backgroundBottomStops: [Gradient.Stop] = [
        .init(color: .midnightEnd, location: 0),
        .init(color: .midnightEnd, location: 0.25),
        .init(color: .sunriseEnd, location: 0.33),
        .init(color: .sunnyDayEnd, location: 0.38),
        .init(color: .sunnyDayEnd, location: 0.7),
        .init(color: .sunsetEnd, location: 0.78),
        .init(color: .midnightEnd, location: 0.82),
        .init(color: .midnightEnd, location: 1)
    ]
    
    let cloudTopStops: [Gradient.Stop] = [
        .init(color: .darkCloudStart, location: 0),
        .init(color: .darkCloudStart, location: 0.25),
        .init(color: .sunriseCloudStart, location: 0.33),
        .init(color: .lightCloudStart, location: 0.38),
        .init(color: .lightCloudStart, location: 0.7),
        .init(color: .sunsetCloudStart, location: 0.78),
        .init(color: .darkCloudStart, location: 0.82),
        .init(color: .darkCloudStart, location: 1)
    ]
    
    let cloudBottomStops: [Gradient.Stop] = [
        .init(color: .darkCloudEnd, location: 0),
        .init(color: .darkCloudEnd, location: 0.25),
        .init(color: .sunriseCloudEnd, location: 0.33),
        .init(color: .lightCloudEnd, location: 0.38),
        .init(color: .lightCloudEnd, location: 0.7),
        .init(color: .sunsetCloudEnd, location: 0.78),
        .init(color: .darkCloudEnd, location: 0.82),
        .init(color: .darkCloudEnd, location: 1)
    ]
    
    let starStops: [Gradient.Stop] = [
        .init(color: .white, location: 0),
        .init(color: .white, location: 0.25),
        .init(color: .clear, location: 0.33),
        .init(color: .clear, location: 0.38),
        .init(color: .clear, location: 0.7),
        .init(color: .clear, location: 0.78),
        .init(color: .white, location: 0.82),
        .init(color: .white, location: 1)
    ]
    
    var starOpacity: Double {
        let color = starStops.interpolated(amount: time)
        return color.getComponents().alpha
    }
    
    var body: some View {
        
        ZStack {
            StarsView()
                .opacity(starOpacity)
            
            CloudsView(
                thickness: $cloudThickness.wrappedValue,
                topTint: cloudTopStops.interpolated(amount: $time.wrappedValue),
                bottomTint: cloudBottomStops.interpolated(amount: $time.wrappedValue)
            )
            
            SunView(progress: $time.wrappedValue)
            
            if $isRainOn.wrappedValue {
                StormView(
                    type: .rain,
                    direction: .degrees($precipitationAngle.wrappedValue),
                    strength: rainIntensity)
            }
            if $isSnowOn.wrappedValue {
                StormView(
                    type: .snow,
                    direction: .degrees($precipitationAngle.wrappedValue),
                    strength: snowIntensity)
            }
            if $isThunderstormOn.wrappedValue {
                LightningView(
                    maximumBolts: Int(lightningMaxBolts),
                    forkProbability: Int(lightningForkProbability))
                .zIndex(1)
            }
        }
        .ignoresSafeArea()
        .frame(maxWidth: UIScreen.screenWidth, maxHeight: UIScreen.screenHeight)
        .background(
            LinearGradient(colors: [
                backgroundTopStops.interpolated(amount: time),
                backgroundBottomStops.interpolated(amount: time)
            ], startPoint: .top, endPoint: .bottom)
        )
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView(
            cloudThickness: .constant(.thick),
            isRainOn: .constant(false),
            isSnowOn: .constant(false),
            isThunderstormOn: .constant(false),
            snowIntensity: .constant(5),
            rainIntensity: .constant(5),
            time: .constant(0.9),
            precipitationAngle: .constant(0.9))
    }
}
