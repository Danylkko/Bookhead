//
//  ContentView.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 04.09.2024.
//

import SwiftUI

struct PlayerTabsView: View {
    
    @State private var selectedTab: PlayerTabs = .player
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                PlayerView()
                    .tag(PlayerTabs.player)
                PlaybackListView()
                    .tag(PlayerTabs.playbackList)
            }
            
            VStack {
                Spacer()
                PlayerTabBarView(selectedTab: $selectedTab)
                    .overlay {
                        RoundedRectangle(cornerRadius: 31)
                            .stroke(Color.gray, lineWidth: 0.5)
                    }
            }
        }
    }
}

#Preview {
    PlayerTabsView()
}
