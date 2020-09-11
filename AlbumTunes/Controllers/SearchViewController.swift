//
//  ViewController.swift
//  AlbumTunes
//
//  Created by Denis Sushkov on 08.09.2020.
//  Copyright © 2020 Denis Sushkov. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    let apiManager = APIManager.shared
    
    let sectionInsets = UIEdgeInsets(top: 10.0,
                                     left: 20.0,
                                     bottom: 50.0,
                                     right: 20.0) //Insets for UICollectionView items
    
    @IBOutlet weak var albumCollectionView: UICollectionView!
    @IBOutlet weak var placeholderView: UIView!
    
    let spinner = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumCollectionView.register(AlbumCollectionViewCell.nib(), forCellWithReuseIdentifier: "albumCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: spinner)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Delegate is set here to be reassigned
        // after returning to Search View Controller
        apiManager.delegate = self
    }
    
    /// prepare(for segue: UIStoryboardSegue, sender: Any?)
    ///
    /// Configures Detail View Controller
    /// to show selected album data and songs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "goToDetail", let album = apiManager.selectedAlbum else {return}
        if let destinationVC = segue.destination as? DetailViewController {
            destinationVC.selectedAlbum = album
        }
    }
}
