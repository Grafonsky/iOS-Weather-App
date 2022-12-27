//
//  LoaderView.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 26.12.22.
//

import SwiftUI

struct LoaderView: View {
    
    @Binding var isLoaded: Bool
    
    var body: some View {
        if !isLoaded {
            Rectangle()
                .foregroundColor(.clear)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
            ProgressView()
        }
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView(isLoaded: .constant(false))
    }
}
