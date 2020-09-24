//
//  AppStoreError.swift
//  AppStoreAPI
//
//  Created by Jason Koceja on 9/24/20.
//

import Foundation

enum AppStoreError : LocalizedError {
    case invalidURL
    case thrownError(Error)
    case invalidData
    case thrownImageError(Error)
    case unableToDecode
}
