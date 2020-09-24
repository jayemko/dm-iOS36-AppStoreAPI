//
//  AppItem.swift
//  AppStoreAPI
//
//  Created by Jason Koceja on 9/24/20.
//

import Foundation

struct AppTopLevelObject : Decodable {
    let results: [AppItem]
}

struct AppItem : Decodable {
    let description: String
    let trackName: String
    let artworkUrl100: URL?
}
