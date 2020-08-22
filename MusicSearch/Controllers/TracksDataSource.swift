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
    func reloadView(page: Int?)
    func showAlert(message: String)
    func showActivityIndicator()
    func hideActivityIndicator()
}

class TracksDataSource: NSObject {
    weak var delegate: TracksDataSourceDelegate?
    var tableView: UITableView
    var trackSearchViewModel = TrackSearchViewModel()
    var trackCellModels = [TrackSearchCellModel]()
    var tracksCount: Int {
        return trackCellModels.count
    }
    
    init(tableView: UITableView, delegate: TracksDataSourceDelegate? = nil) {
        self.tableView = tableView
        self.delegate = delegate
        super.init()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.getTopTracks(artist: Constants.initialSearch)
    }
    
    func getTopTracks(artist: String) {
        delegate?.showActivityIndicator()
        trackSearchViewModel.getTopTracks(artist: artist, page: 1, autocorrect: false) {
            [weak self] result in
            self?.delegate?.hideActivityIndicator()
            switch result {
            case .success(let value):
                if let cellModels = value {
                    self?.trackCellModels = cellModels
                }
            case .failure(let error):
                print(error)
                if error != SessionTaskError.responseError {
                    self?.delegate?.showAlert(message: error.errorMessage)
                }
            }
            self?.reloadTableView()
        }
    }
    
    func reloadPageData() {
        delegate?.showActivityIndicator()
        trackSearchViewModel.reloadPage() {
            [weak self] result in
            self?.delegate?.hideActivityIndicator()
            switch result {
            case .success(let value):
                if let cellModels = value {
                    self?.trackCellModels = cellModels
                    self?.reloadTableView()
                }
            case .failure(let error):
                print(error)
                if error != SessionTaskError.responseError {
                    self?.delegate?.showAlert(message: error.errorMessage)
                }
            }
        }
    }
    
    func searchArtist(_ searchText: String) {
        let artist = searchText.isEmpty ? (trackSearchViewModel.lastSearchedArtist.isEmpty ? Constants.initialSearch : trackSearchViewModel.lastSearchedArtist) : searchText
        self.getTopTracks(artist: artist)
    }
    
    func loadNextPageTracks() {
        trackSearchViewModel.currentPageIndex += 1
        reloadPageData()
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.delegate?.reloadView(page: self.trackSearchViewModel.currentPageIndex)
        }
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
        cell.setTrackInfo(trackCellModel: trackCellModels[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard tracksCount > 40 else { return }
        
        if indexPath.section == tracksCount - 1 {
            loadNextPageTracks()
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
