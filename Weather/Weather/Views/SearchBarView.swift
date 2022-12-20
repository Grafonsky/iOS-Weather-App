//
//  SearchBarView.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 20.12.22.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    @Binding var isSearching: Bool
    @Binding var isSearchBarExpand: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.init(hex: "323232"))
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("searchBar".localizable, text: $searchText) { isStartedEditing in
                    if isStartedEditing {
                        withAnimation {
                            isSearching = true
                        }
                    }
                } onCommit: {
                    withAnimation {
                        isSearching = false
                    }
                }
            }
            .foregroundColor(.gray)
            .padding(.leading, 13)
        }
        .frame(height: isSearchBarExpand ? 40 : 0)
        .cornerRadius(13)
        .padding()
        .preferredColorScheme(.dark)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray
            SearchBarView(
                searchText: .constant(""),
                isSearching: .constant(false),
                isSearchBarExpand: .constant(true))
        }
    }
}
