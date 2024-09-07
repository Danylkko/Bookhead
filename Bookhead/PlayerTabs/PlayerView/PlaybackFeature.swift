//
//  PlaybackFeature.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 09.09.2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct PlaybackFeature: Reducer {
    
    let environment: PlaybackEnvironment = .init(
        playbackService: PlaybackService.shared
    )
    
    @ObservableState
    struct State: Equatable {
        var isPlaying: Bool = false
        var currentTime: Double = 0.0
        var totalTime: Double = 0.0
        var playbackSpeed: PlaybackSpeed = .x1
        var isChangingSpeedEnabled: Bool = false
        
        var timeInMinutes: String {
            currentTime.minutesAndSeconds
        }
        
        var totalTimeInMinutes: String {
            totalTime.minutesAndSeconds
        }
    }
    
    enum Action: Equatable {
        case play(url: URL)
        case resume
        case pause
        case rewind(seconds: Double)
        case startFrom(time: Double)
        case goForwards
        case goBackwards
        case changeSpeed(PlaybackSpeed)
        case changeTrack(next: Bool)
        case updateTime(seconds: Double)
        case releaseSlider
    }
    
    enum CancelId: Hashable {
        case timer
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .play(let url):
                environment
                    .playbackService
                    .setup(with: url)
                state.totalTime = environment.playbackService.totalTime
                return .run { send
                    in await send(.resume)
                }
                
            case .resume:
                state.isPlaying = true
                state.isChangingSpeedEnabled = environment.playbackService.isChangingSpeedEnabled
                environment.playbackService.play()
                return .run { send in
                    let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
                    
                    for await _ in timer.values {
                        let currentTime = environment.playbackService.currentTime
                        await send(.updateTime(seconds: currentTime))
                    }
                }
                .cancellable(id: CancelId.timer, cancelInFlight: true)
            case .pause:
                state.isPlaying = false
                environment.playbackService.pause()
                return .none
            case .rewind(let seconds):
                let newTime = state.currentTime + seconds
                if newTime > state.totalTime {
                    return .run { send in await send(.goForwards) }
                } else if newTime < 0 {
                    return .run { send in await send(.goBackwards) }
                } else {
                    environment.playbackService.rewind(seconds: seconds)
                }
                return .none
            case .startFrom(let time):
                state.currentTime = time
                environment.playbackService.startFrom(time: time)
                return .run { send in await send(.resume) }
            case .goForwards:
                environment.playbackService.goForwards()
                return .none
            case .goBackwards:
                environment.playbackService.goBackwards()
                return .none
            case .changeSpeed(let speed):
                state.playbackSpeed = speed
                environment.playbackService.changeSpeed(speed)
                return .none
            case .changeTrack:
                return .none
            case .updateTime(let seconds):
                state.currentTime = seconds
                if abs(state.totalTime - state.currentTime) < 0.5 {
                    return .run { send in
                        await send(.changeTrack(next: true))
                    }
                }
                return .none
            case .releaseSlider:
                return .cancel(id: CancelId.timer)
            }
        }
    }
}
