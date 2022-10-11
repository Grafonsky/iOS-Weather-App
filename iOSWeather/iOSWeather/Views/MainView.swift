//
//  MainView.swift
//  iOSWeather
//
//  Created by Bohdan Hawrylyshyn on 11.10.2022.
//

import SwiftUI

struct MainView: View {
    
    @State private var selectedTab: TabModel = .weather
    @State private var tabMidPoints: [CGFloat] = []
    
    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
            TabView(selection: $selectedTab) {
                WeatherView()
                    .tag(TabModel.weather)
                CitiesView()
                    .tag(TabModel.cities)
            }
            VStack {
                Spacer()
                TabBar(selectedTab: $selectedTab, tabMidPoints: $tabMidPoints)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
