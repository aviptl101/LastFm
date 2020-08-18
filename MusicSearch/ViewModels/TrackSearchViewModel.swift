//
//  TrackSearchViewModel.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 16/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

protocol TrackSearchViewModelDelegate: NSObject {
    func reloadTableView(page: Int?)
    func showAlert(message: String)
    func showActivityIndicator()
    func hideActivityIndicator()
}

final class TrackSearchViewModel {
    weak var delegate: TrackSearchViewModelDelegate?
    var newSearchTopTracks: [TopTrack]?
    var allTopTracks = [TopTrack]()
    var trackCellModels = [TrackSearchCellModel]()
    var tracksCount: Int {
        return trackCellModels.count
    }
    var currentPageIndex = 1
    var lastSearchedArtist = ""
    
    init(artist: String, autocorrect: Bool) {
        Configuration.shared.configure(apiKey: Constants.apiKey)
        getTopTracks(artist: artist, page: 1, autocorrect: autocorrect)
    }
    
    func getTopTracks(artist: String, page: Int, autocorrect: Bool,completion: (() -> Void)? = nil) {
        if artist.isEmpty { return }
        delegate?.showActivityIndicator()
        RequestManager.getTopTracks(endPoint: .getTopTracks(artist: artist, page: page, autocorrect: autocorrect)) { [weak self] (result) in
            self?.delegate?.hideActivityIndicator()
            switch result {
            case .success(let value):
                //print(value)
                self?.newSearchTopTracks = value.list
                self?.getTrackCellModels()
                self?.currentPageIndex = page
                self?.lastSearchedArtist = artist
            case .failure(let error):
                print(error)
                if error != SessionTaskError.responseError {
                    self?.delegate?.showAlert(message: error.errorMessage)
                }
            }
            completion?()
        }
    }
    
    func loadNextPageTracks(completion: (() -> Void)? = nil) {
        currentPageIndex += 1
        if lastSearchedArtist.isEmpty {
            lastSearchedArtist = Constants.initialSearch
        }
        getTopTracks(artist: lastSearchedArtist, page: currentPageIndex, autocorrect: false, completion: completion)
    }
    
    func reloadPage(completion: (() -> Void)? = nil) {
        if lastSearchedArtist.isEmpty {
            lastSearchedArtist = Constants.initialSearch
        }
        getTopTracks(artist: lastSearchedArtist, page: currentPageIndex, autocorrect: false, completion: completion)
    }
    
    func searchArtist(_ searchText: String, completion: (() -> Void)? = nil) {
        let artist = searchText.isEmpty ? (lastSearchedArtist.isEmpty ? Constants.initialSearch : lastSearchedArtist) : searchText
        getTopTracks(artist: artist, page: 1, autocorrect: false, completion: completion)
    }
    
    private func getTrackCellModels() {
        guard let tracks = newSearchTopTracks else { return }
        
        if currentPageIndex == 1 {
            // Removing all Models if its New Search
            trackCellModels.removeAll()
            allTopTracks = tracks
        } else {
            // Otherwise appending next page tracks
            allTopTracks.append(contentsOf: tracks)
        }
        
        for track in tracks {
            let trackCellModel = TrackSearchCellModel(trackImage: track.image[0].url, trackTitle: track.name, artistTitle: track.artist?.name)
            self.trackCellModels.append(trackCellModel)
        }
        self.delegate?.reloadTableView(page: currentPageIndex)
    }
}
