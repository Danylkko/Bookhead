//
//  PlaybackControlStyle.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 08.09.2024.
//

import SwiftUI

struct PlaybackControlStyle: ButtonStyle {
    
    enum Constants {
        static let pressedButtonScale: CGFloat = 0.8
        static let underlyingViewSize: CGSize = .init(width: 45, height: 45)
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? Constants.pressedButtonScale : 1)
            .background {
                if configuration.isPressed {
                    Circle()
                        .fill(
                            configuration.isPressed ?
                            AppColor.controlButtonUnderlyingColor.color :
                                    .clear
                        )
                        .frame(
                            width: Constants.underlyingViewSize.width,
                            height: Constants.underlyingViewSize.height
                        )
                }
            }
    }
}
