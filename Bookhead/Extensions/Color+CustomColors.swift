//
//  Color+CustomColors.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 04.09.2024.
//

import SwiftUI

enum AppColor: String {
    case playerBackgroundColor
    case tabItemAccentForegroundColor
    case tabItemAccentBackgroundColor
}

extension AppColor: AssetColorProtocol { }

protocol AssetColorProtocol {
    var rawValue: String { get }
}

extension AssetColorProtocol {
    var color: Color {
        return Color(rawValue, bundle: nil)
    }
}
