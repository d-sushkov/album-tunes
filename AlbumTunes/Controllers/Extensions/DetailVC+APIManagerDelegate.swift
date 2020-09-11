//
//  DetailVC+APIManagerDelegate.swift
//  AlbumTunes
//
//  Created by Denis Sushkov on 11.09.2020.
//  Copyright © 2020 Denis Sushkov. All rights reserved.
//

import Foundation

extension DetailViewController: APIManagerDelegate {
    
    /// didUpdateSongs()
    ///
    /// Checks if song results were retreived,
    /// and updates UI to show a list of songs
    func didUpdateSongs() {
        songsRetrieved = .yes
        guard apiManager.songsResult != nil else {return}
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.songsTableView.reloadData()
        }
    }
    
    /// didFailWithError()
    ///
    /// Checks if song results were not retreived,
    /// and updates UI to show error table view cell
    func didFailWithError() {
        songsRetrieved = .no
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.songsTableView.reloadData()
        }
    }
    
    func didUpdateAlbums() {}
}
