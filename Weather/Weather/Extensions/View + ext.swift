//
//  View + ext.swift
//  Weather
//
//  Created by Bohdan Hawrylyshyn on 10.11.2022.
//

import SwiftUI

extension View {
    @inlinable func reverseMask<Mask: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ mask: () -> Mask) -> some View {
            self.mask(
                ZStack {
                    Rectangle()
                    mask()
                        .blendMode(.destinationOut)
                }
            )
        }
}
