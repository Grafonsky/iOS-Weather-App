//
//  RootView.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 24.12.22.
//

import SwiftUI

struct RootView: View {
    
    @ObservedObject var viewModel: RootViewModel
    
    @State var isFavoritesSheetShow = false
    @State var selectedCity = 0
    
    private var locationService: LocationService
    private var cityIterator = 0
    
    init(viewModel: RootViewModel, locationService: LocationService) {
        self.viewModel = viewModel
        self.locationService = locationService
    }
    
    var body: some View {
        
        let current = viewModel.cities.first
        
        ZStack {
            
            SignatureView()
                .frame(height: UIScreen.screenHeight * 0.6)
            
            if $viewModel.isLoaded.wrappedValue {
                ZStack {
                    TabView(selection: $selectedCity) {
                        ForEach(0..<$viewModel.cities.count, id: \.self) { i in
                            let city = $viewModel.cities[i].wrappedValue
                            let weatherType: WeatherType = city == current ? .current : .favorite(data: city)
                            WeatherView(viewModel: .init(
                                weatherType: weatherType,
                                locationService: locationService))
                            .tag(i)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .ignoresSafeArea()
                    
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                isFavoritesSheetShow = true
                            } label: {
                                Image(systemName: "list.bullet")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 25)
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .sheet(
                        isPresented: $isFavoritesSheetShow,
                        onDismiss: {
                            viewModel.loadCities()
                            isFavoritesSheetShow = false
                        }) {
                            FavoritesView(
                                viewModel: .init(weatherService: viewModel.weatherService),
                                isFavoritesSheetShow: $isFavoritesSheetShow,
                                selectedCity: $selectedCity)
                        }
                }
            } else {
                ZStack {
                    Color.init(hex: "1d1d1d")
                        .ignoresSafeArea()
                    LoaderView(isLoaded: $viewModel.isLoaded)
                }
            }
            
            if !$viewModel.isLocationAllowed.wrappedValue {
                if viewModel.isFirstLaunch {
                    CheckLocationView(appLaunchState: .first)
                } else {
                    CheckLocationView(appLaunchState: .subsequent)
                }
            }
        }
        .onAppear {
            viewModel.isFirstLaunch = false
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            viewModel: .init(),
            locationService: .init())
    }
}
