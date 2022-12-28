//
//  NoInternetView.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 27.12.22.
//

import SwiftUI

struct NoInternetView: View {
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.red)
                    .frame(height: 65)
                HStack {
                    Image(systemName: "wifi.slash")
                    Text("noInternet".localizable)
                        .font(.customFont(weight: .medium, size: 18))
                }
            }
            .foregroundColor(.white)
            Spacer()
        }
    }
}

struct NoInternetView_Previews: PreviewProvider {
    static var previews: some View {
        NoInternetView()
    }
}
