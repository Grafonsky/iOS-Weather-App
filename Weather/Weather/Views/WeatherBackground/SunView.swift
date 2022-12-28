//
//  SunView.swift
//  InstaWeather — https://www.patreon.com/posts/weather-app-76384109
// MARK: -
//  Instagram — https://www.instagram.com/iam_iosdev/
//  Patreon — https://www.patreon.com/danielswift/posts
// MARK: -
//
//  Created by Daniel Swift on 10/11/2022.
//

import SwiftUI

struct SunView: View {
    let progress: Double
    
    @State private var haloScale = 1.0
    @State private var sunRotation = 0.0
    @State private var flareDistance = 80.0
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Circle().fill(.clear)
                    .frame(height: 180)
                ZStack {
                    
                    Image("halo")
                        .blur(radius: 3)
                        .scaleEffect(haloScale)
                        .opacity(sin(progress * .pi) * 3 - 2)
                    
                    Image("sun")
                        .blur(radius: 2)
                        .rotationEffect(.degrees(sunRotation))
                    
                    VStack {
                        Spacer()
                            .frame(height: 200)
                        
                        ForEach(0..<3) { i in
                            Circle()
                                .fill(.white.opacity(0.2))
                                .frame(width: 16 + Double(i * 10), height: 16 + Double(i * 10))
                                .padding(.top, 40 + (sin(Double(i) / 2) * flareDistance))
                                .blur(radius: 1)
                                .opacity(sin(progress * .pi) - 0.7)
                        }
                    }
                }
            }
            .blendMode(.screen)
            .position(x: proxy.frame(in: .global).width * sunX , y: 50)
            .rotationEffect(.degrees((progress - 0.5) * 180))
            .onAppear {
                withAnimation(.easeInOut(duration: 7).repeatForever(autoreverses: true)) {
                    haloScale = 1.3
                }
                
                withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                    sunRotation = 20
                }
                
                withAnimation(.easeInOut(duration: 30).repeatForever(autoreverses: true)) {
                    flareDistance = -70
                }
            }
        }
        .ignoresSafeArea()
    }
    
    var sunX: Double {
        (progress - 0.3) * 1.5
    }
}
