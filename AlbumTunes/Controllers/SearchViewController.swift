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
    @IBOutlet weak var placeholderLabel: UILabel!
    
    let spinner = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumCollectionView.register(AlbumCollectionViewCell.nib(), forCellWithReuseIdentifier: "albumCell")
        apiManager.notification.addObserver(self,
                                            selector: #selector(didUpdateAlbums),
                                            name: NSNotification.Name(rawValue: "albumsUpdated"),
                                            object: nil)
        apiManager.notification.addObserver(self,
                                            selector: #selector(didFailWithError),
                                            name: NSNotification.Name(rawValue: "errorOccured"),
                                            object: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: spinner)
    }
    
    /// didUpdateAlbums()
    ///
    /// Checks if album search results were received
    /// and updates UI with data model
    @objc private func didUpdateAlbums() {
        guard let albums = apiManager.albumsSearchResult else {return}
        DispatchQueue.main.async {
            self.albumCollectionView.reloadData()
            self.spinner.stopAnimating()
            if albums.count != 0 {
                self.placeholderView.isHidden = true
            } else {
                self.showAlert(titleText: "No Results")
            }
        }
    }
    
    /// didFailWithError()
    ///
    /// Checks if album search results were not received
    /// and updates UI to show error
    @objc private func didFailWithError() {
        
        guard apiManager.albumsSearchResult == nil else {return}
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
    
    /// prepare(for segue: UIStoryboardSegue, sender: Any?)
    ///
    /// Configures Detail View Controller
    /// to show selected album data and songs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "goToDetail", let album = apiManager.selectedAlbum else {return}
        let destinationVC = segue.destination as! DetailViewController
        destinationVC.selectedAlbum = album
    }
}
