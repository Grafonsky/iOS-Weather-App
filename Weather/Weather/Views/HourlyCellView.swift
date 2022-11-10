//
//  HourlyCellView.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 30.10.2022.
//

import SwiftUI

struct HourlyCellView: View {
    
    @Binding var hour: String
    @Binding var icon: String
    @Binding var temp: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(hour)
            Image(systemName: icon)
            Text(temp)
        }
        .font(.customFont(weight: .medium, size: 17))
        .foregroundColor(.white)
    }
}

struct HourlyCellView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyCellView(
            hour: .constant("Now"),
            icon: .constant("111"),
            temp: .constant("1°"))
    }
}
