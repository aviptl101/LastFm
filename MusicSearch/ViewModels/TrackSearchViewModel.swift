//
//  TrackSearchViewModel.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 16/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

typealias SearchResult = Result<[TrackSearchCellModel]?, SessionTaskError>

final class TrackSearchViewModel {
    var allTopTracks = [TopTrack]()
    var currentPageIndex = 1
    var lastSearchedArtist = ""
    
    init() {
        Configuration.shared.configure(apiKey: Constants.apiKey)
    }
    
    func getTopTracks(artist: String, page: Int, autocorrect: Bool, completion: @escaping (SearchResult) -> Void) {
        if artist.isEmpty { return }
        RequestManager.getTopTracks(endPoint: .getTopTracks(artist: artist, page: page, autocorrect: autocorrect)) { [weak self] (result) in
            switch result {
            case .success(let value):
                self?.currentPageIndex = page
                self?.lastSearchedArtist = artist
                let cellModels = self?.getTrackCellModels(topTracks: value.list)
                completion(.success(cellModels))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func reloadPage(completion: ((SearchResult) -> Void)? = nil) {
        if lastSearchedArtist.isEmpty {
            lastSearchedArtist = Constants.initialSearch
        }
        getTopTracks(artist: lastSearchedArtist, page: currentPageIndex, autocorrect: false) { (result) in
            completion?(result)
        }
    }
    
    private func getTrackCellModels(topTracks: [TopTrack]?) -> [TrackSearchCellModel]? {
        guard let tracks = topTracks else { return nil }
        
        if currentPageIndex == 1 {
            allTopTracks = tracks
        } else {
            // Otherwise appending next page tracks
            allTopTracks.append(contentsOf: tracks)
        }
        
        var cellModels = [TrackSearchCellModel]()
        for track in allTopTracks {
            let trackCellModel = TrackSearchCellModel(trackImage: track.image[0].url, trackTitle: track.name, artistTitle: track.artist?.name)
            cellModels.append(trackCellModel)
        }
        return cellModels
    }
}
