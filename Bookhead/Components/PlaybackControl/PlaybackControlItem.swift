//
//  PlaybackControlItem.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 07.09.2024.
//

import Foundation

enum PlaybackControlItem: String {
    case backwards
    case goBackwards5
    case pause
    case play
    case goForwards10
    case forwards
    
    var imageName: String {
        switch self {
        case .backwards:
            return "backwards"
        case .goBackwards5:
            return "goBackwards5"
        case .pause:
            return "pause"
        case .play:
            return "play"
        case .goForwards10:
            return "goForwards10"
        case .forwards:
            return "forwards"
        }
    }
}
