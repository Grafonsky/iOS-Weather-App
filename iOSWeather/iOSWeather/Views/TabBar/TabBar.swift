//
//  TabBar.swift
//  iOSWeather
//
//  Created by Bohdan Hawrylyshyn on 11.10.2022.
//

import SwiftUI

struct TabBar: View {
    
    @Binding var selectedTab: TabModel
    @Binding var tabMidPoints: [CGFloat]
    
    var body: some View {
        ZStack {
            HStack {
                TabBarButton(
                    tab: .weather,
                    selectedTab: $selectedTab,
                    tabMidPoints: $tabMidPoints)
                TabBarButton(
                    tab: .cities,
                    selectedTab: $selectedTab,
                    tabMidPoints: $tabMidPoints)
            }
            .padding()
            .background(
                Color.white
                    .clipShape(
                        TabBarClipShape(tabMidPoint: getCurvePoint() - 15)
                    )
            )
            .overlay(
                Circle()
                    .fill(selectedTab.selectedColor)
                    .frame(width: 10)
                    .offset(x: getCurvePoint() - 20),
                alignment: .bottomLeading
            )
            .cornerRadius(30)
            .padding(.horizontal)
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

private extension TabBar {
    
    func getCurvePoint() -> CGFloat {
        if tabMidPoints.isEmpty {
            return 55
        } else {
            switch selectedTab {
            case .weather:
                return tabMidPoints[0]
            case .cities:
                return tabMidPoints[1]
            }
        }
    }
    
}
