//
//  SearchVC+SearchBar.swift
//  AlbumTunes
//
//  Created by Denis Sushkov on 08.09.2020.
//  Copyright © 2020 Denis Sushkov. All rights reserved.
//

import UIKit

extension SearchViewController: UISearchBarDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // add UISearchBar to UICollectionView header
        let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "searchBar", for: indexPath)
        return searchView
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchRequest = searchBar.text else {return}
        if searchRequest != "" {
            spinner.startAnimating()
            apiManager.fetchAlbumsData(searchRequest: searchRequest)
        } else {
            searchBar.placeholder = "Type something"
        }
    }
}
