//
//  DetailViewController.swift
//  AlbumTunes
//
//  Created by Denis Sushkov on 08.09.2020.
//  Copyright © 2020 Denis Sushkov. All rights reserved.
//

import UIKit
import AVFoundation

enum loadingState {
    case yes, no, loading
} // YES if got results, NO if failed with error, LOADING if still in process

class DetailViewController: UIViewController {
    
    var player = AVPlayer()
    var nowPlaying: IndexPath?
    
    let apiManager = APIManager.shared
    var selectedAlbum: APICallAlbumsResult?
    let spinner = UIActivityIndicatorView(style: .medium)
    
    var songsRetrieved = loadingState.loading
    
    @IBOutlet weak var albumArtImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumGenreLabel: UILabel!
    @IBOutlet weak var albumCopyrightLabel: UILabel!
    @IBOutlet weak var songsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didMinimizeApp),
                                               name: NSNotification.Name(rawValue: "stopPlaying"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: spinner)
        songsTableView.register(SongTableViewCell.nib(), forCellReuseIdentifier: "songCell")
        updateViewContent()
        apiManager.delegate = self
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
        
        apiManager.fetchSongsData(albumID: album.collectionId)
    }
    
    /// didMinimizeApp()
    ///
    /// Stops the player and updates "play" icon
    /// when app enters background
    @objc private func didMinimizeApp() {
        player.pause()
        stopPlayingPreview()
    }
    
    /// didFinishPlaying()
    ///
    /// Updates UI when playerItem plays to the end
    @objc private func didFinishPlaying() {
        stopPlayingPreview()
    }
}
