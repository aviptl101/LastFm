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
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Artist"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        refreshControl.addTarget(self, action: #selector(getSearchData), for: .valueChanged)
        refreshControl.backgroundColor = .clear
        refreshControl.frame = tableView.frame
        refreshControl.center = tableView.center
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.isHidden = true
        refreshControl.isHidden = true
        
        trackSearchViewModel = TrackSearchViewModel(artist: Constants.initialSearch, autocorrect: false)
        trackSearchViewModel?.delegate = self
    }
    
    @objc private func getSearchData() {
        trackSearchViewModel?.reloadPage()
    }
    
    // MARK: TrackSearchViewModelDelegate Methods
    
    func reloadTableView(page: Int?) {
        if trackSearchViewModel?.tracksCount == 0 {
            showAlert(message: "No Data Found")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if let page = page {
                self.pageLabel.text = "Page: \(page)"
            }
        }
    }
    
    func showAlert(message: String) {
        DispatchQueue.main.async {
            Utility.showAlert(title: "Alert", message: message, for: self)
        }
    }
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.refreshControl.endRefreshing()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}

extension MasterViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return trackSearchViewModel?.tracksCount ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.SearchCellIdentifier, for: indexPath) as! TrackSearchCell
        if let cellModels = trackSearchViewModel?.trackCellModels {
            cell.setTrackInfo(trackCellModel: cellModels[indexPath.section])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let count = trackSearchViewModel?.tracksCount, count > 40 else { return }
        
        if indexPath.section == count - 1 {
            trackSearchViewModel?.loadNextPageTracks()
        }
        
        //Updating Page Count to Page Label
        let pageIndex = (indexPath.section / Constants.itemsPerPage) + 1
        self.pageLabel.text = "Page: \(pageIndex)"
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

extension MasterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let trackDetailsVC = storyboard.instantiateViewController(withIdentifier: "TrackDetailsVC") as! TrackDetailsViewController
        trackDetailsVC.trackInfo = trackSearchViewModel?.allTopTracks[indexPath.section]
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
