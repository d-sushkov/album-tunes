# Album Tunes
> iTunes album searching app

## Table of contents
* [General info](#general-info)
* [Screenshots](#screenshots)
* [Technologies](#technologies)
* [Technical details](#technical-details)
* [Features and UI](#features-and-ui)
* [Contact](#contact)

## General info
Album Tunes is the application for the iPhone that displays album artwork from the [iTunes API](https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/). The user can see detailed information about the selected album.

## Screenshots
![Example screenshot](https://i.imgur.com/pasNFtB.png)
![Example screenshot](https://i.imgur.com/T8S1PMq.png)

## Technologies
* Xcode - version 11.7
* Swift - version 5.2
* SDWebImage - version 5.9.0

## Technical details
The app uses classic MVC architecture.

Albums' and songs' data is retrieved with standart URLRequest; the resulting JSON is parsed using Codable protocol; View controllers work with retrieved data using Delegate protocol.

Album artwork is loaded and cached using SDWebImage (dependency installed with Swift Package Manager)

Song snippets can be played using AVPlayer

## Features and UI
* iTunes albums searching with UISearchBar
* Albums are sorted alphabetically and displayed in UICollectionView
* Tap on album to see details and tracklist in UITableView
* Playable song snippets with play/stop indicator
* Navigation between screens with UINavigationController

## Contact
Created by [Denis Sushkov](https://t.me/denis_sush)
