//
//  TabBarButton.swift
//  iOSWeather
//
//  Created by Bohdan Hawrylyshyn on 11.10.2022.
//

import SwiftUI

struct TabBarButton: View {
    
    var tab: TabModel
    @Binding var selectedTab: TabModel
    @Binding var tabMidPoints: [CGFloat]
    
    var body: some View {
        GeometryReader { reader -> AnyView in
            let midX = reader.frame(in: .global).midX
            DispatchQueue.main.async {
                tabMidPoints.append(midX)
            }
            
            let view = AnyView(
                Button {
                    withAnimation(
                        .interactiveSpring(
                            response: 0.6,
                            dampingFraction: 0.55,
                            blendDuration: 0.3)) {
                                selectedTab = tab
                            }
                } label: {
                    VStack (spacing: 5) {
                        let isSelected = tab == selectedTab
                        
                        Image(isSelected ? tab.selectedIconName : tab.nonSelectedIconName)
                            .offset(y: isSelected ? -10 : 0)
                            .foregroundColor(isSelected ? tab.selectedColor : tab.nonSelectedColor)
                        
                        Text(tab.tabName)
                            .offset(y: isSelected ? -5 : 0)
                            .font(.customFont(
                                weight: .medium,
                                size: 15))
                            .foregroundColor(isSelected ? tab.selectedColor : tab.nonSelectedColor)
                    }
                    
                }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
            return view
        }
        .frame(maxHeight: 55)
    }
}

struct TabBarButton_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
