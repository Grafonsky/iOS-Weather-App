//
//  FavoritesView.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 20.12.22.
//

import SwiftUI
import Foundation

struct FavoritesView: View {
    
    @ObservedObject var viewModel: FavoritesViewModel
    
    @State private var isSearchBarExpand = true
    @State private var offset: CGFloat = .zero
    
    @Binding var isFavoritesSheetShow: Bool
    @Binding var selectedCity: Int
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color.init(hex: "1d1d1d")
                    .ignoresSafeArea()
                
                VStack {
                    SearchBarView(
                        searchText: $viewModel.searchText,
                        isSearching: $viewModel.isSearching,
                        isSearchBarExpand: $isSearchBarExpand,
                        isResponseReceived: $viewModel.isResponseReceived,
                        searchTextSubject: $viewModel.searchTextSubject)
                    
                    if $viewModel.isSearching.wrappedValue {
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(.init(hex: "1d1d1d"))
                            
                            if viewModel.searchText.isEmpty {
                                Text("startTyping".localizable)
                                    .font(.customFont(weight: .bold, size: 15))
                                    .foregroundColor(.gray)
                            } else {
                                List {
                                    ForEach($viewModel.searchableCities, id: \.id) { city in
                                        Button {
                                            viewModel.addCitySubject.send(city.wrappedValue)
                                            withAnimation {
                                                viewModel.isSearching = false
                                                viewModel.searchText = ""
                                            }
                                        } label: {
                                            HStack {
                                                let name = city.name.wrappedValue
                                                let region = city.region.wrappedValue
                                                let country = city.country.wrappedValue
                                                
                                                Text(getFlag(from: city.code.wrappedValue))
                                                Text("\(name), \(region), \(country)")
                                            }
                                        }
                                    }
                                }
                                
                                if !$viewModel.isResponseReceived.wrappedValue {
                                    LoaderView(isLoaded: $viewModel.isResponseReceived)
                                }
                            }
                        }
                    } else {
                        
                        List {
                            ForEach(0..<$viewModel.favoriteCities.count) { i in
                                let itemWrapped = $viewModel.favoriteCities[i].wrappedValue
                                let title = itemWrapped.name ?? ""
                                let subtitle = getTime(timeOffset: Int(itemWrapped.weather?.timeOffset ?? 0))
                                let weatherDescription = itemWrapped.weather?.weatherDescription?.capitalizingFirstLetter() ?? ""
                                let currentTemp = Int(itemWrapped.weather?.temp ?? 0.0)
                                let minTemp = Int(itemWrapped.weather?.maxTemp ?? 0.0)
                                let maxTemp = Int(itemWrapped.weather?.minTemp ?? 0.0)
                                let isCurrentLocation = itemWrapped == viewModel.favoriteCities.first
                                let icon = itemWrapped.weather?.icon ?? ""
                                
                                FavoriteCityCell(
                                    title: title,
                                    subtitle: subtitle,
                                    weatherDescription: weatherDescription,
                                    currentTemp: currentTemp,
                                    minMaxTemp: "H:\(maxTemp)° L:\(minTemp)°",
                                    isCurrentLocation: isCurrentLocation,
                                    icon: icon)
                                .onTapGesture {
                                    isFavoritesSheetShow = false
                                    selectedCity = i
                                }
                                .deleteDisabled(isCurrentLocation)
                            }
                            
                            .onDelete(perform: delete)
                            .listRowBackground(Color.clear)
                            .background(
                                GeometryReader {
                                    Color.clear.preference(
                                        key: ViewOffsetKey.self,
                                        value: -$0.frame(in: .named("scroll")).origin.y)
                                })
                            .onPreferenceChange(ViewOffsetKey.self) {
                                if $0 > 0 {
                                    withAnimation(.linear(duration: 0.05)) {
                                        isSearchBarExpand = false
                                        UIApplication.shared.dismissKeyboard()
                                    }
                                }
                                if $0 < 0 {
                                    withAnimation(.linear(duration: 0.05)) {
                                        isSearchBarExpand = true
                                    }
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .coordinateSpace(name: "scroll")
                        .gesture(DragGesture()
                            .onChanged({ _ in
                                UIApplication.shared.dismissKeyboard()
                            })
                        )
                    }
                    
                }
                .toolbar {
                    if $viewModel.isSearching.wrappedValue {
                        Button("cancel".localizable) {
                            viewModel.searchText = ""
                            withAnimation {
                                $viewModel.isSearching.wrappedValue = false
                                UIApplication.shared.dismissKeyboard()
                            }
                        }
                    }
                }
                .navigationTitle($viewModel.isSearching.wrappedValue ? "search".localizable : "favCities".localizable)
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        let index = offsets.first ?? 0
        viewModel.removeCitySubject.send(index)
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = .zero
    static func reduce(
        value: inout Value,
        nextValue: () -> Value) {
            value += nextValue()
        }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(
            viewModel: .init(weatherService: .init(locationService: .init())),
            isFavoritesSheetShow: .constant(false),
            selectedCity: .constant(0))
    }
}

private extension FavoritesView {
    func getTime(timeOffset: Int) -> String {
        let currentTime = DateFormatterService.shared.dateToString(
            time: Int(Date().timeIntervalSince1970),
            timezoneOffset: timeOffset,
            dateType: .sunMove)
        return currentTime
    }
    
    func getFlag(from countryCode: String) -> String {
        countryCode
            .unicodeScalars
            .map({ 127397 + $0.value })
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
}
