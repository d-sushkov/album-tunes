//
//  APIDataModel.swift
//  AlbumTunes
//
//  Created by Denis Sushkov on 08.09.2020.
//  Copyright © 2020 Denis Sushkov. All rights reserved.
//

import Foundation

/// AlbumsResultModel: Codable
/// APICallAlbumsResult: Codable
///
/// Data structures for decoding
/// iTunes API albums' search result
struct AlbumsResultModel: Codable {
    let results: [APICallAlbumsResult]
}

struct APICallAlbumsResult: Codable {
    let collectionName: String
    let artistName: String
    let artworkUrl100: String
    let collectionId: Int
    let primaryGenreName: String
    let releaseDate: String
    let copyright: String?
}

/// SongsResultModel: Codable
/// APICallSongsResult: Codable
///
/// Data structures for decoding
/// iTunes API songs' list result
struct SongsResultModel: Codable {
    var results: [APICallSongsResult]
}

struct APICallSongsResult: Codable {
    let trackName: String?
    let previewUrl: String?
    let trackNumber: Int?
    var isPlaying: Bool? //custom property. Will always be nil after API Call
}
