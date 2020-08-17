//
//  MasterViewController.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 16/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import UIKit

final class MasterViewController: UIViewController, TrackSearchViewModelDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pageLabel: UILabel!
    private var trackSearchViewModel: TrackSearchViewModel?
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Artist"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        trackSearchViewModel = TrackSearchViewModel(artist: Constants.initialSearch, autocorrect: false)
        trackSearchViewModel?.delegate = self
    }
    
    // MARK: TrackSearchViewModelDelegate Methods
    
    func reloadTableView(page: Int?) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if let page = page {
                self.pageLabel.text = "Page: \(page)"
            }
        }
    }
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}

extension MasterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return trackSearchViewModel?.tracksCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchTrackTableViewCell
        if let cellModels = trackSearchViewModel?.trackCellModels {
            cell.setTrackInfo(trackCellModel: cellModels[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let count = trackSearchViewModel?.tracksCount else { return }
        
        if indexPath.row == count - 1 {
            trackSearchViewModel?.loadNextPageTracks()
        }
        
        //Updating Page Count to Page Label
        let pageIndex = (indexPath.row / Constants.itemsPerPage) + 1
        self.pageLabel.text = "Page: \(pageIndex)"
    }
}

extension MasterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let trackDetailsVC = storyboard.instantiateViewController(withIdentifier: "TrackDetailsVC") as! TrackDetailsViewController
        trackDetailsVC.trackInfo = trackSearchViewModel?.allTopTracks[indexPath.row]
        trackDetailsVC.modalPresentationStyle = .overFullScreen
        self.present(trackDetailsVC, animated: false)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let searchText = searchBar.text else { return }
        trackSearchViewModel?.searchArtist(searchText)
    }
}
