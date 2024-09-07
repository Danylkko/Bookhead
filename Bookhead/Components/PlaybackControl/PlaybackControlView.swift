//
//  PlaybackControlView.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 07.09.2024.
//

import SwiftUI

struct PlaybackControlView: View {
    
    var item: PlaybackControlItem
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(item.imageName)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 34, height: 34)
                .colorMultiply(AppColor.iconMainTintColor.color)
        }
        .buttonStyle(PlaybackControlStyle())
    }
}

