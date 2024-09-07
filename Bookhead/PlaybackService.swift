//
//  PlaybackService.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 08.09.2024.
//

import AVFoundation
import ComposableArchitecture

struct PlaybackEnvironment {
    let playbackService: PlaybackServiceProtocol
    
    init(playbackService: PlaybackServiceProtocol) {
        self.playbackService = playbackService
    }
}

protocol PlaybackServiceProtocol {
    func setup(with url: URL)
    func play()
    func pause()
    func rewind(seconds: Double)
    func startFrom(time: Double)
    func goForwards()
    func goBackwards()
    func changeSpeed(_ speed: PlaybackSpeed)
    var currentTime: Double { get }
    var totalTime: Double { get }
    var isChangingSpeedEnabled: Bool { get }
}

final class PlaybackService {
    static let shared = PlaybackService()
    private var url: URL?
    private var player: AVAudioPlayer?
    
    func setup(with url: URL) {
        if self.url != url {
            self.url = url
            self.player = try? .init(contentsOf: url)
        }
    }
    
    private init() { }
}

extension PlaybackService: PlaybackServiceProtocol {

    func play() {
        player?.play()
    }

    func pause() {
        player?.pause()
    }

    func rewind(seconds: Double) {
        guard let player = player else { return }
        player.currentTime += seconds
    }

    func startFrom(time: Double) {
        player?.currentTime = time
    }

    func goForwards() {
        guard let player = player else { return }
        player.currentTime = min(player.currentTime + 10, player.duration)
    }

    func goBackwards() {
        guard let player = player else { return }
        player.currentTime = max(player.currentTime - 10, 0)
    }

    func changeSpeed(_ speed: PlaybackSpeed) {
        player?.rate = speed.rawValue
    }

    var currentTime: Double {
        player?.currentTime ?? 0
    }

    var totalTime: Double {
        player?.duration ?? 0
    }
    
    var isChangingSpeedEnabled: Bool {
        player?.enableRate ?? false
    }
}
