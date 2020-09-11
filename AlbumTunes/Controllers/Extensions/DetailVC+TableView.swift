//
//  DetailVC+TableView.swift
//  AlbumTunes
//
//  Created by Denis Sushkov on 08.09.2020.
//  Copyright © 2020 Denis Sushkov. All rights reserved.
//

import UIKit

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if songsRetrieved == .yes {
            return apiManager.songsResult?.count ?? 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch songsRetrieved {
        case .yes:
            // create and return song cell
            let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.identifier, for: indexPath) as! SongTableViewCell
            if let songInfo = apiManager.songsResult?[indexPath.row] {
                cell.configure(with: songInfo)
            }
            return cell
        case .no:
            // create and return error cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "errorCell", for: indexPath)
            cell.textLabel?.text = "Unable to load tracklist"
            return cell
        case .loading:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playPauseItem(row: indexPath.row)
        
        if let currentSong = nowPlaying, currentSong != indexPath {
            // if another song was tapped, update "play" icon on both
            apiManager.songsResult?[currentSong.row].isPlaying = false
            tableView.reloadRows(at: [indexPath, currentSong], with: .automatic)
        } else {
            // if the same song was tapped, update "play" icon on it
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        nowPlaying = indexPath
    }
}
