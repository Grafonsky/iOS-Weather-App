//
//  CheckLocationView.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 26.12.22.
//

import SwiftUI

enum AppLaucnhState {
    case first, subsequent
}

struct CheckLocationView: View {
    
    @State var appLaunchState: AppLaucnhState
    
    var body: some View {
        ZStack {
            Color.init(hex: "1d1d1d")
                .ignoresSafeArea()
            
            switch appLaunchState {
            case .first:
                VStack(spacing: 25) {
                    Text("firstLaunchLocationAccess".localizable)
                    Image(systemName: "location.viewfinder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 55)
                    Spacer()
                        .frame(height: UIScreen.screenHeight * 0.6)
                    VStack(spacing: 5) {
                        Text("https://github.com/Grafonsky")
                        Text("https://linkedin.com/in/grafonsky")
                    }
                    
                }
                .frame(width: UIScreen.screenWidth * 0.9)
                
            case .subsequent:
                ZStack {
                    VStack(spacing: 5) {
                        Spacer()
                            .frame(height: UIScreen.screenHeight * 0.8)
                        Text("https://github.com/Grafonsky")
                        Text("https://linkedin.com/in/grafonsky")
                    }
                    VStack(spacing: 25) {
                        Text("subsequentLaunchLocationAccess".localizable)
                        Image(systemName: "location.viewfinder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 55)
                        
                        let settingsURL = URL(string: UIApplication.openSettingsURLString)
                        Button {
                            UIApplication.shared.open(
                                settingsURL ?? .init(fileURLWithPath: ""),
                                options: [:],
                                completionHandler: nil)
                        } label: {
                            Text("Tap for open settings")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .foregroundColor(.init(hex: "a8a8a8"))
        .multilineTextAlignment(.center)
    }
}

struct CheckLocationView_Previews: PreviewProvider {
    static var previews: some View {
        CheckLocationView(appLaunchState: .first)
    }
}
