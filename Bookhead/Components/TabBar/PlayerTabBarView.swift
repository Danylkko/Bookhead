//
//  PlayerTabBarView.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 04.09.2024.
//

import SwiftUI

struct PlayerTabBarView: View {
    
    @Binding var selectedTab: PlayerTabs
    
    var body: some View {
        HStack(spacing: 15) {
            ForEach(PlayerTabs.allCases, id: \.rawValue) { item in
                PlayerTabItemView(
                    tab: item,
                    selectedTab: $selectedTab
                )
                .clipShape(Circle())
                .padding(5)
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .overlay {
            RoundedRectangle(cornerRadius: 31)
                .stroke(Color.gray, lineWidth: 0.5)
        }
    }
}
