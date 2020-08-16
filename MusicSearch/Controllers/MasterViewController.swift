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
    private var trackSearchViewModel: TrackSearchViewModel?
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Artist"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        trackSearchViewModel = TrackSearchViewModel(artist: "Cher", autocorrect: false)
        trackSearchViewModel?.delegate = self
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
}

extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let searchText = searchBar.text else { return }
        trackSearchViewModel?.searchArtist(searchText)
    }
}

extension MasterViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    }
}
