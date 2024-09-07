//
//  ContentView.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 04.09.2024.
//

import SwiftUI
import ComposableArchitecture

struct PlayerTabsView: View {
    
    enum Constants {
        static let tabViewBottomPadding: CGFloat = 10
    }
    
    @State private var selectedTab: PlayerTabs = .player
    @Bindable var store: StoreOf<AppFeature>
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                PlayerView(
                    albumStore: store.scope(
                        state: \.playerState,
                        action: \.player
                    ),
                    songStore: store.scope(
                        state: \.playbackState,
                        action: \.playback
                    )
                )
                .tag(PlayerTabs.player)
                PlayerTextTab()
                    .tag(PlayerTabs.playbackList)
            }
            
            VStack {
                Spacer()
                PlayerTabBarView(selectedTab: $selectedTab)
            }
            .padding(.bottom, Constants.tabViewBottomPadding)
        }
        .onAppear {
            let urls = StorageService(
                bundle: .main,
                subpath: nil
            ).urls(for: "m4a")
            store.send(.player(.start(urls: urls)))
        }
    }
}

#Preview {
    PlayerTabsView(
        store: .init(
            initialState: .initial,
            reducer: { AppFeature() }
        )
    )
}
