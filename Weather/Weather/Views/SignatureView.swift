//
//  SignatureView.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 26.12.22.
//

import SwiftUI

struct SignatureView: View {
    var body: some View {
        ZStack {
            Color.init(hex: "1d1d1d")
                .ignoresSafeArea()
            
            HStack {
                VStack(spacing: 5) {
                    ForEach((1...99), id: \.self) { _ in
                        Text("/Grafonsky")
                    }
                }
                
                Spacer()
                
                VStack(spacing: 10) {
                    ForEach((1...99), id: \.self) { _ in
                        Text("/Grafonsky")
                    }
                }
            }
            .frame(width: UIScreen.screenWidth * 0.95)
        }
        .foregroundColor(.init(hex: "292929"))
        .font(.customFont(weight: .bold, size: 14))
    }
}

struct SignatureView_Previews: PreviewProvider {
    static var previews: some View {
        SignatureView()
    }
}
