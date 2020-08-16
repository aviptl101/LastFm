//
//  TrackSearchViewModel.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 16/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

protocol TrackSearchViewModelDelegate: NSObject {
    func reloadTableView()
}

final class TrackSearchViewModel {
    weak var delegate: TrackSearchViewModelDelegate?
    var trackCellModels = [TrackSearchCellModel]()
    var topTracks: [TopTrack]?
    var tracksCount: Int {
        return trackCellModels.count
    }
    
    init(artist: String, autocorrect: Bool) {
        Configuration.shared.configure(apiKey: "3e993d0279bd62c8160982392010f7bf")
        getTopTracks(artist: artist, autocorrect: autocorrect)
    }

    func getTopTracks(artist: String, autocorrect: Bool) {
        RequestManager.getTopTracks(endPoint: .getTopTracks(artist: artist, autocorrect: autocorrect)) { [weak self] (result) in
            switch result {
            case .success(let value):
                print(value)
                self?.topTracks = value.list
                self?.getTrackCellModels()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getTrackCellModels() {
        guard let tracks = topTracks else { return }
        trackCellModels.removeAll()
        for track in tracks {
            let trackCellModel = TrackSearchCellModel(trackImage: track.image[0].url, trackTitle: track.name, artistTitle: track.artist?.name)
            self.trackCellModels.append(trackCellModel)
        }
        self.delegate?.reloadTableView()
    }
}
