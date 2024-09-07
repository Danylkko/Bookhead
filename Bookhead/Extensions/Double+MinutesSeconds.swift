//
//  Float+MinutesSeconds.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 07.09.2024.
//

import Foundation

extension Double {
    var minutesAndSeconds: String {
        let totalSeconds = Int(self)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
