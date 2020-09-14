//
//  SearchVC+APIManagerDelegate.swift
//  AlbumTunes
//
//  Created by Denis Sushkov on 11.09.2020.
//  Copyright © 2020 Denis Sushkov. All rights reserved.
//

import UIKit

extension SearchViewController: APIManagerDelegate {
    
    /// didUpdateAlbums()
    ///
    /// Checks if album search results were received
    /// and updates UI with data model
    func didUpdateAlbums() {
        guard let albums = apiManager.albumsSearchResult else {return}
        DispatchQueue.main.async {
            self.albumCollectionView.reloadData()
            self.spinner.stopAnimating()
            if albums.count != 0 {
                self.placeholderView.isHidden = true
            } else {
                self.showAlert(titleText: "No Results")
                self.placeholderView.isHidden = false
            }
        }
    }
    
    /// didFailWithError()
    ///
    /// Checks if album search results were not received
    /// and updates UI to show error
    func didFailWithError() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.showAlert(titleText: "Error loading data!")
        }
    }
    
    /// createAlert(titleText: String)
    ///
    /// Creates and presents UIAlertController
    /// with error text
    ///
    /// Parameters   : titleText: Alert's title text
    private func showAlert(titleText: String) {
        let alert = UIAlertController(title: titleText, message: "Try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func didUpdateSongs() {}

}
