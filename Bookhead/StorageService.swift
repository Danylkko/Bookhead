//
//  StorageService.swift
//  Bookhead
//
//  Created by Danylo Litvinchuk on 08.09.2024.
//

import Foundation

protocol StorageServiceProtocol {
    func urls(for resourceExtension: String) -> [URL]
}

final class StorageService {
    
    let bundle: Bundle
    let subpath: String?
    
    init(
        bundle: Bundle = .main,
        subpath: String?
    ) {
        self.bundle = bundle
        self.subpath = subpath
    }
    
}

extension StorageService: StorageServiceProtocol {
    
    func urls(for resourceExtension: String) -> [URL] {
        bundle.urls(
            forResourcesWithExtension: resourceExtension,
            subdirectory: subpath
        ) ?? []
    }
    
}
