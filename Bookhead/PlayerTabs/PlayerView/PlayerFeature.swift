//
//  PlayerFeature.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 08.09.2024.
//

import Foundation
import Combine
import ComposableArchitecture

@Reducer
struct PlayerFeature: Reducer {
    
    let environment: PlayerEnvironment = .init(
        audioResouseService: AudioResourceService()
    )
    
    @ObservableState
    struct State: Equatable {
        var urls: [URL] = []
        
        var currentIndex: Int = 0
        var artist: String? = nil
        var artwork: Data? = nil
        
        var totalNumber: Int {
            urls.count
        }
    }
    
    enum Action: Equatable {
        case start(urls: [URL])
        case play(url: URL)
        case audioReceived(Result<AudioFileModel, BHError>)
        case changeTrack(next: Bool)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .start(let urls):
                state.urls = urls
                let currentUrl = urls[state.currentIndex]
                return .run { [currentUrl] send in
                    await send(.audioReceived(
                        environment
                            .audioResourceService
                            .loadAudio(for: currentUrl)
                    ))
                    await send(.play(url: currentUrl))
                }
            case .audioReceived(.success(let model)):
                state.artist = model.artist
                state.artwork = model.artwork
                return .none
            case .audioReceived(.failure(let error)):
                print("⛔️ An error occured \(error)")
                return .none
            case .play:
                return .none
            case .changeTrack(let next):
                let newTrackIndex = state.currentIndex + (next ? 1 : -1)
                if (0..<state.totalNumber) ~= newTrackIndex {
                    state.currentIndex = newTrackIndex
                    return .run { [urls = state.urls] send in
                        await send(.start(urls: urls))
                    }
                } else {
                    return .none
                }
            }
        }
    }
    
}
