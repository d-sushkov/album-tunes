//
//  AlbumCollectionViewCell.swift
//  AlbumTunes
//
//  Created by Denis Sushkov on 08.09.2020.
//  Copyright © 2020 Denis Sushkov. All rights reserved.
//

import UIKit
import SDWebImage

/// AlbumCollectionViewCell: UICollectionViewCell
///
/// Custom cell for displaying
/// Album art and title in UICollectionView
class AlbumCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "albumCell"
    
    @IBOutlet weak var albumArtImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "AlbumCollectionViewCell", bundle: nil)
    }
    
    /// configure(with model: APICallAlbumsResult)
    ///
    /// Configures the cell's contents
    /// with albums' search result from API call
    ///
    /// Parameters   : model: Data model for configuration
    func configure(with model: APICallAlbumsResult) {
        if let url = URL(string: model.artworkUrl100) {
            albumArtImageView.sd_setImage(with: url, completed: nil)
        }
        albumTitleLabel.text = model.collectionName
        artistLabel.text = model.artistName
    }
}
