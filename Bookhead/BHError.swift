//
//  BHError.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 08.09.2024.
//

import Foundation

enum BHError: Error, Equatable {
    case outOfBounds
    case couldNotLoadMetadata
    case other(desciption: String)
}
