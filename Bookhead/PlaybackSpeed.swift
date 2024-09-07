//
//  PlaybackSpeed.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 07.09.2024.
//

import Foundation

enum PlaybackSpeed: Float, CaseIterable {
    case x1 = 1.0
    case x15 = 1.5
    case x2 = 2.0
    
    var displayValue: String {
        String(format: "%.1f", rawValue)
    }
}
