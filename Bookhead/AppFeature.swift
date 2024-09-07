//
//  MainFeature.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 09.09.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AppFeature: Reducer {
    
    struct State: Equatable {
        var playbackState: PlaybackFeature.State
        var playerState: PlayerFeature.State
        
        static var initial: Self {
            .init(
                playbackState: .init(),
                playerState: .init()
            )
        }
    }
    
    enum Action: Equatable {
        case play(url: URL)
        case changeTrack(next: Bool)
        case playback(PlaybackFeature.Action)
        case player(PlayerFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            switch action {
            case .player(.play(let url)):
                return .run { send in
                    await send(.playback(.play(url: url)))
                }
            case .playback(.changeTrack(let next)):
                return .run { send in
                    await send(.player(.changeTrack(next: next)))
                }
            default:
                return .none
            }
        }
        
        Scope(
            state: \.playbackState,
            action: \.playback
        ) {
            PlaybackFeature()
        }
        
        Scope(
            state: \.playerState,
            action: \.player
        ) {
            PlayerFeature()
        }
    }
}
