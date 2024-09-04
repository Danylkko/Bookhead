//
//  PlayerTabItemView.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 04.09.2024.
//

import SwiftUI

struct PlayerTabItemView: View {
    
    var tab: PlayerTabs
    @Binding var selectedTab: PlayerTabs
    
    var isCurrentTabSelected: Bool {
        tab == selectedTab
    }
    
    var body: some View {
        Button {
            selectedTab = tab
        } label: {
            Image(tab.imageName)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .foregroundStyle(isCurrentTabSelected ? tab.accentForegroundColorName.color : .black)
                .padding()
        }
        .background(isCurrentTabSelected ? tab.accentBackgroundColorName.color : .clear)
    }
}
