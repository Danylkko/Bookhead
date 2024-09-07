//
//  AssetColorProtocol.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 07.09.2024.
//

import SwiftUI

protocol AssetColorProtocol {
    var rawValue: String { get }
}

extension AssetColorProtocol {
    var color: Color {
        return Color(rawValue, bundle: nil)
    }
}
