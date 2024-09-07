//
//  PlayerTabs.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 04.09.2024.
//

import Foundation

enum PlayerTabs: String, CaseIterable {
    case player
    case playbackList
    
    var imageName: String {
        switch self {
        case .player:
            return "player"
        case .playbackList:
            return "list"
        }
    }
    
    var accentBackgroundColorName: AppColor {
        switch self {
        case .player, .playbackList:
            return .tabItemAccentBackgroundColor
        }
    }
    
    var accentForegroundColorName: AppColor {
        switch self {
        case .player, .playbackList:
            return .tabItemAccentForegroundColor
        }
    }
}
