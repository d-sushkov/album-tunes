//
//  SongTableViewCell.swift
//  AlbumTunes
//
//  Created by Denis Sushkov on 08.09.2020.
//  Copyright © 2020 Denis Sushkov. All rights reserved.
//

import UIKit

/// SongTableViewCell: UITableViewCell
///
/// Custom cell for displaying
/// song data in UITableView
class SongTableViewCell: UITableViewCell {
    
    static let identifier = "songCell"
    
    @IBOutlet weak var songNumberLabel: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var playImageView: UIImageView!
    
    static func nib() -> UINib {
        return UINib(nibName: "SongTableViewCell", bundle: nil)
    }
    
    /// configure(with model: APICallSongsResult)
    ///
    /// Configures the cell's contents
    /// with songs' result from API call
    ///
    /// Parameters   : model: Data model for configuration
    func configure(with model: APICallSongsResult) {
        songNumberLabel.text = "\(model.trackNumber ?? 0)"
        songTitleLabel.text = model.trackName
        if model.previewUrl != nil { // if the song's preview can be played
            if model.isPlaying == true { // if the song is playing now
                playImageView.image = UIImage(systemName: "stop.circle")
            } else {
                playImageView.image = UIImage(systemName: "play.circle")
            }
            playImageView.isHidden = false
        }
    }
}
