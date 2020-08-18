//
//  TracksDataSource.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 18/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import UIKit

protocol TracksDataSourceDelegate: AnyObject {
    func presentTrackDetailsVC(trackDetailsVC: UIViewController)
    func updatePageLabel(with index: Int)
}

class TracksDataSource: NSObject {
    weak var delegate: TracksDataSourceDelegate?
    var tableView: UITableView
    var trackSearchViewModel: TrackSearchViewModel
    var tracksCount: Int {
        return trackSearchViewModel.tracksCount
    }
    
    init(tableView: UITableView, delegate: TracksDataSourceDelegate? = nil) {
        self.tableView = tableView
        self.delegate = delegate
        self.trackSearchViewModel = TrackSearchViewModel(artist: Constants.initialSearch, autocorrect: false)
        super.init()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func getSearchData(completion: (() -> Void)? = nil) {
        trackSearchViewModel.reloadPage(completion: completion)
    }
    
    func searchArtist(_ searchText: String, completion: (() -> Void)? = nil) {
        trackSearchViewModel.searchArtist(searchText, completion: completion)
    }
}

extension TracksDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tracksCount
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.SearchCellIdentifier, for: indexPath) as! TrackSearchCell
        cell.setTrackInfo(trackCellModel: trackSearchViewModel.trackCellModels[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard tracksCount > 40 else { return }
        
        if indexPath.section == tracksCount - 1 {
            trackSearchViewModel.loadNextPageTracks()
        }
        
        //Updating Page Count to Page Label
        let pageIndex = (indexPath.section / Constants.itemsPerPage) + 1
        delegate?.updatePageLabel(with: pageIndex)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.sizeToFit()
        headerView.backgroundColor = .systemGroupedBackground
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}

extension TracksDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let trackDetailsVC = storyboard.instantiateViewController(withIdentifier: "TrackDetailsVC") as? TrackDetailsViewController else { return }
        trackDetailsVC.trackInfo = trackSearchViewModel.allTopTracks[indexPath.section]
        trackDetailsVC.modalPresentationStyle = .overFullScreen
        delegate?.presentTrackDetailsVC(trackDetailsVC: trackDetailsVC)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
