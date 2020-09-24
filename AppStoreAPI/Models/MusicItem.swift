//
//  MusicItem.swift
//  AppStoreAPI
//
//  Created by Jason Koceja on 9/24/20.
//

import Foundation

struct MusicTopLevelObject : Decodable {
    let results: [MusicItem]
}

struct MusicItem : Decodable {
    let artistName: String
    let trackName: String
    let artworkUrl100: URL?
}
