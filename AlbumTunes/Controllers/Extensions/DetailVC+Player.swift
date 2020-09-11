//
//  DetailVC+Player.swift
//  AlbumTunes
//
//  Created by Denis Sushkov on 10.09.2020.
//  Copyright © 2020 Denis Sushkov. All rights reserved.
//

import UIKit
import AVFoundation

extension DetailViewController {
    
    /// playPauseItem(row: Int)
    ///
    /// Checks if song snippet in current row is playing,
    /// if yes, stops playing,
    /// if no, calls playSongPreview to start playing
    ///
    /// Parameters   : row: Number of row to play song from
    func playPauseItem(row: Int) {
        guard let song = apiManager.songsResult?[row] else {return}
        if song.isPlaying == true {
            player.pause()
            apiManager.songsResult?[row].isPlaying = false
        } else {
            guard let safeUrl = song.previewUrl else {return}
            playSongPreview(urlString: safeUrl)
            apiManager.songsResult?[row].isPlaying = true
        }
    }
    
    /// playSongPreview(urlString: String)
    ///
    /// Checks if any song snippet is playing now,
    /// if yes, replaces it with selected song,
    /// if no, configures and starts a new player
    ///
    /// Parameters   : urlString: selected song preview URL string
    func playSongPreview(urlString: String) {
        guard let url = URL(string: urlString) else {return}
        let playerItem: AVPlayerItem = AVPlayerItem(url: url)
        if player.currentItem != nil {
            player.pause()
            // Not using .replaceCurrentItem because
            // poor network condition causes sound glitching
            // when changing songs
        }
        player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 50)
        self.view.layer.addSublayer(playerLayer)
        player.play()
    }
}
