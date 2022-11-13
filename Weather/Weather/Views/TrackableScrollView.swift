//
//  TrackableScrollView.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 2.11.2022.
//

import SwiftUI

struct TrackableScrollView<Content>: View where Content: View {
    
    @Binding var contentOffset: CGFloat
    
    let axes: Axis.Set
    let showIndicators: Bool
    let content: Content
    
    init(_ axes: Axis.Set = .vertical,
         showIndicators: Bool = true,
         contentOffset: Binding<CGFloat>,
         @ViewBuilder content: () -> Content) {
        
        _contentOffset = contentOffset
        self.axes = axes
        self.showIndicators = showIndicators
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { outsideProxy in
            ScrollView(self.axes, showsIndicators: self.showIndicators) {
                ZStack(alignment: self.axes == .vertical ? .top : .leading) {
                    GeometryReader { insideProxy in
                        Color.clear
                            .preference(
                                key: ScrollOffsetPreferenceKey.self,
                                value: [self.calculateContentOffset(
                                    fromOutsideProxy: outsideProxy,
                                    insideProxy: insideProxy)])
                    }
                    VStack {
                        self.content
                    }
                }
            }
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                self.contentOffset = value[0]
            }
        }
    }
    
    private func calculateContentOffset(fromOutsideProxy outsideProxy: GeometryProxy, insideProxy: GeometryProxy) -> CGFloat {
        if axes == .vertical {
            return outsideProxy.frame(in: .global).minY - insideProxy.frame(in: .global).minY
        } else {
            return outsideProxy.frame(in: .global).minX - insideProxy.frame(in: .global).minX
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = [CGFloat]
    
    static var defaultValue: [CGFloat] = [0]
    
    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}
