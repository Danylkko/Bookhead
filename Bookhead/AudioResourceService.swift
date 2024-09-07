//
//  AudioResourceService.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 09.09.2024.
//

import AVFoundation

struct AudioFileModel: Equatable {
    let duration: Double
    let artist: String?
    let artwork: Data?
}

struct PlayerEnvironment {
    let audioResourceService: AudioResourceServiceProtocol
    
    init(audioResouseService: AudioResourceServiceProtocol) {
        self.audioResourceService = audioResouseService
    }
}

protocol AudioResourceServiceProtocol {
    func loadAudio(for url: URL) async -> Result<AudioFileModel, BHError>
}

final class AudioResourceService {
    private var url: URL? = nil
    private var asset: AVAsset!
}

extension AudioResourceService: AudioResourceServiceProtocol {
    
    func loadAudio(for url: URL) async -> Result<AudioFileModel, BHError> {
        if self.url != url {
            self.url = url
            self.asset = AVAsset(url: url)
        }
        
        var duration: Double = 0
        var artist: String?
        var artwork: Data?
        do {
            duration = try await loadDuration()
            artist = try await loadMetadata(for: .commonKeyArtist, metadataItem: .stringValue)
            artwork = try await loadMetadata(for: .commonKeyArtwork, metadataItem: .dataValue)
        } catch {
            return .failure(.other(desciption: error.localizedDescription))
        }
        
        return .success(.init(
            duration: duration,
            artist: artist,
            artwork: artwork
        ))
    }
    
    private func loadDuration() async throws -> Double {
        let duration: CMTime = try await asset.load(.duration)
        return CMTimeGetSeconds(duration)
    }
    
    private func loadMetadata<T>(
        for commonKey: AVMetadataKey,
        metadataItem: AVAsyncProperty<AVMetadataItem, T?>
    ) async throws -> T? {
        let metadata: [AVMetadataItem]
        metadata = try await asset.load(.metadata)
        
        for item in metadata where item.commonKey == commonKey {
            let data = try await item.load(metadataItem)
            return data
        }
        
        return nil
    }
    
}
