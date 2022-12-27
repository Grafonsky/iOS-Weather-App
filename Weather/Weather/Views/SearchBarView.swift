//
//  SearchBarView.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 20.12.22.
//

import SwiftUI
import Combine

struct SearchBarView: View {
    
    @Binding var searchText: String
    @Binding var isSearching: Bool
    @Binding var isSearchBarExpand: Bool
    @Binding var isResponseReceived: Bool
    @Binding var searchTextSubject: PassthroughSubject<String, Never>
    
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
                .onChange(of: searchText) { newValue in
                    isResponseReceived = false
                    searchTextSubject.send(newValue)
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
                isSearchBarExpand: .constant(true),
                isResponseReceived: .constant(true),
                searchTextSubject: .constant(.init()))
        }
    }
}
