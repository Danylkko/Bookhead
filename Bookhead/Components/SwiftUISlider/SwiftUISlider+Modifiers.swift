//
//  SwiftUISlider+Modifiers.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 07.09.2024.
//

import SwiftUI

extension SwiftUISlider {
    func tintColor(_ color: Color) -> some View {
        self.modifier(TintColorModifier(tintColor: color))
    }
}

struct TintColorModifier: ViewModifier {
    let tintColor: Color
    
    func body(content: Content) -> some View {
        content
            .tint(tintColor)
    }
}
