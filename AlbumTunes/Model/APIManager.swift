//
//  APIManager.swift
//  AlbumTunes
//
//  Created by Denis Sushkov on 08.09.2020.
//  Copyright © 2020 Denis Sushkov. All rights reserved.
//

import Foundation

protocol APIManagerDelegate: AnyObject {
    func didUpdateAlbums()
    func didUpdateSongs()
    func didFailWithError()
}

class APIManager {
    
    weak var delegate: APIManagerDelegate?
    
    static let shared = APIManager()
    
    var albumsSearchResult: [APICallAlbumsResult]?
    var songsResult: [APICallSongsResult]?
    var selectedAlbum: APICallAlbumsResult?
    
    private let albumsSearchURLString = "https://itunes.apple.com/search"
    private let songsURLString = "https://itunes.apple.com/lookup"
    
    
    /// fetchAlbumsData(searchRequest: String)
    ///
    /// Creates a query using text entered in
    /// search field and calls a function to perform
    /// request with it
    ///
    /// Parameters   : searchRequest: user's search request
    func fetchAlbumsData(searchRequest: String) {
        if var urlComponents = URLComponents(string: albumsSearchURLString) {
            urlComponents.query = "media=music&entity=album&term=\(searchRequest)"
            guard let url = urlComponents.url else {return}
            performRequest(with: url)
        }
    }
    
    /// fetchSongsData(albumID: Int)
    ///
    /// Creates a URL using selected album's ID
    /// and calls a function to perform request with it
    ///
    /// Parameters   : albumID: selected album's ID
    func fetchSongsData(albumID: Int) {
        let urlString = songsURLString + ("?id=\(albumID)&entity=song")
        guard let url = URL(string: urlString) else {return}
        performRequest(with: url)
    }
    
    /// performRequest(with url: URL)
    ///
    /// Uses given URL to create a URL session data task,
    /// starts the task and calls a function to update results
    /// if succeeds
    ///
    /// Parameters   : url: URL for iTunes API call
    private func performRequest(with url: URL) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                self.delegate?.didFailWithError()
                print("Error retrieving API data: \(error!.localizedDescription)")
            } else {
                self.updateResults(url: url, data: data)
            }
        }
        task.resume()
    }
    
    /// updateResults(url: URL, data: Data?)
    ///
    /// Defines the type of received data (albums or songs),
    /// calls a function to decode data,
    /// notifies that data was updated,
    /// saves decoded data to APIManager's property
    ///
    /// Parameters   : url: URL for iTunes API call
    ///           : data: data received from API call
    private func updateResults(url: URL, data: Data?) {
        guard let safeData = data else {return}
        if url.absoluteString.contains("search") { //if retrieved albums' data
            let albums = self.parseJSON(safeData, isSearching: true) as? AlbumsResultModel
            self.albumsSearchResult = albums?.results.sorted(by: {a, b in
                return a.collectionName < b.collectionName // sorted alphabetically
            })
            delegate?.didUpdateAlbums()
        } else { // if retrieved songs' data
            var result = self.parseJSON(safeData, isSearching: false) as? SongsResultModel
            result?.results.removeFirst() //first result doesn't contain songs' info
            self.songsResult = result?.results
            delegate?.didUpdateSongs()
        }
    }
    
    /// parseJSON(_ apiData: Data, isSearching: Bool) -> Any?
    ///
    /// Decodes given data
    ///
    /// Parameters   : apiData: data received from API call
    ///           : isSsearching: defines API call type (searching albums or getting songs)
    ///
    /// Return Value : Any?: decoded data (is succeded) or nil
    private func parseJSON(_ apiData: Data, isSearching: Bool) -> Any? {
        let decoder = JSONDecoder()
        do {
            if isSearching { //if decoding albums' data
                let decodedData = try decoder.decode(AlbumsResultModel.self, from: apiData)
                return decodedData
            } else { // if decoding songs' data
                let decodedData = try decoder.decode(SongsResultModel.self, from: apiData)
                return decodedData
            }
        } catch {
            delegate?.didFailWithError()
            print("Error decoding data: \(error.localizedDescription)")
            return nil
        }
    }
}
