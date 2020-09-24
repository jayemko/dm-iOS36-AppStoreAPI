//
//  MusicItem.swift
//  AppStoreAPI
//
//  Created by Jason Koceja on 9/24/20.
//

import Foundation

struct MusicTopLevelObject : Decodable {
    let results: [MusicTrack]
}

struct MusicTrack : Decodable {
    let artistName: String
    let trackName: String
    let artworkUrl100: URL?
}
