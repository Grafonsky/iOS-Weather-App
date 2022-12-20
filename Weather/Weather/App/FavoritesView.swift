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
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color.init(hex: "1d1d1d")
                    .ignoresSafeArea()
                
                VStack {
                    SearchBarView(
                        searchText: $viewModel.searchText,
                        isSearching: $viewModel.isSearching,
                        isSearchBarExpand: $isSearchBarExpand)
                    
                    if $viewModel.isSearching.wrappedValue {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.init(hex: "1d1d1d"))
                            
                            if viewModel.searchText.isEmpty {
                                Text("startTyping".localizable)
                                    .font(.customFont(weight: .bold, size: 15))
                                    .foregroundColor(.gray)
                            }
                        }
                    } else {
                        ScrollView {
                            VStack {
                                ForEach($viewModel.cities, id: \.id) { item in
                                    
                                    let itemWrapped = item.wrappedValue
                                    let title = itemWrapped.name ?? ""
                                    let subtitle = getTime(timeOffset: Int(itemWrapped.weather?.timeOffset ?? 0))
                                    let weatherDescription = itemWrapped.weather?.weatherDescription?.capitalizingFirstLetter() ?? ""
                                    let currentTemp = Int(itemWrapped.weather?.temp ?? 0.0)
                                    let minTemp = Int(itemWrapped.weather?.maxTemp ?? 0.0)
                                    let maxTemp = Int(itemWrapped.weather?.minTemp ?? 0.0)
                                    
                                    FavoriteCityCell(
                                        title: title,
                                        subtitle: subtitle,
                                        weatherDescription: weatherDescription,
                                        currentTemp: currentTemp,
                                        minMaxTemp: "H:\(maxTemp)° L:\(minTemp)°")
                                }
                            }
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
        FavoritesView(viewModel: .init())
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
}
