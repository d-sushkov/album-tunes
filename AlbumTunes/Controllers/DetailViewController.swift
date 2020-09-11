//
//  DetailViewController.swift
//  AlbumTunes
//
//  Created by Denis Sushkov on 08.09.2020.
//  Copyright © 2020 Denis Sushkov. All rights reserved.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController {
    
    var player = AVPlayer()
    var nowPlaying: IndexPath?
    
    let apiManager = APIManager.shared
    var selectedAlbum: APICallAlbumsResult?
    private let spinner = UIActivityIndicatorView(style: .medium)
    
    enum loadingState {
        case yes, no, loading
    } // YES if got results, NO if failed with error, LOADING if still in process
    
    var songsRetrieved = loadingState.loading
    
    @IBOutlet weak var albumArtImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumGenreLabel: UILabel!
    @IBOutlet weak var albumCopyrightLabel: UILabel!
    @IBOutlet weak var songsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiManager.notification.addObserver(self,
                                            selector: #selector(didUpdateSongs),
                                            name: NSNotification.Name(rawValue: "songsUpdated"),
                                            object: nil)
        apiManager.notification.addObserver(self,
                                            selector: #selector(didFailWithError),
                                            name: NSNotification.Name(rawValue: "errorOccured"),
                                            object: nil)
        apiManager.notification.addObserver(self,
                                            selector: #selector(didMinimizeApp),
                                            name: NSNotification.Name(rawValue: "stopPlaying"),
                                            object: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: spinner)
        songsTableView.register(SongTableViewCell.nib(), forCellReuseIdentifier: "songCell")
        updateViewContent()
    }
    
    /// updateViewContent()
    ///
    /// Updates UI with data model
    /// and makes an API call to get songs' data
    private func updateViewContent() {
        guard let album = selectedAlbum else {return}
        spinner.startAnimating()
        albumArtImageView.sd_setImage(with: URL(string: album.artworkUrl100), completed: nil)
        albumTitleLabel.text = album.collectionName
        artistNameLabel.text = album.artistName
        albumGenreLabel.text = album.primaryGenreName
        albumCopyrightLabel.text = album.copyright
        
        apiManager.fetchSongsData(albumID: selectedAlbum!.collectionId)
    }
    
    /// didUpdateSongs()
    ///
    /// Checks if song results were retreived,
    /// and updates UI to show a list of songs
    @objc private func didUpdateSongs() {
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
    @objc private func didFailWithError() {
        songsRetrieved = .no
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.songsTableView.reloadData()
        }
    }
    
    /// didMinimizeApp()
    ///
    /// Stops the player and updates "play" icon
    /// when app enters background
    @objc private func didMinimizeApp() {
        player.pause()
        guard let currentSong = nowPlaying else {return}
        apiManager.songsResult?[currentSong.row].isPlaying = false
        songsTableView.reloadRows(at: [currentSong], with: .none)
    }
}
