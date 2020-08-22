//
//  MasterViewController.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 16/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import UIKit

final class MasterViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pageLabel: UILabel!
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    var dataSource: TracksDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = TracksDataSource(tableView: tableView, delegate: self)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Artist"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        refreshControl.addTarget(self, action: #selector(reloadSearchData), for: .valueChanged)
        refreshControl.backgroundColor = .clear
        refreshControl.frame = tableView.frame
        refreshControl.center = tableView.center
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.isHidden = true
        refreshControl.isHidden = true
    }
    
    @objc private func reloadSearchData() {
        dataSource.reloadPageData()
    }
    
    // MARK: TrackSearchViewModelDelegate Methods
}

extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let searchText = searchBar.text else { return }
        dataSource.searchArtist(searchText)
    }
}

extension MasterViewController: TracksDataSourceDelegate {
    func presentTrackDetailsVC(trackDetailsVC: UIViewController) {
        present(trackDetailsVC, animated: false)
    }
    
    func updatePageLabel(with index: Int) {
        pageLabel.text = "Page: \(index)"
    }
    
    func reloadView(page: Int?) {
        if dataSource.tracksCount == 0 {
            showAlert(message: "No Data Found")
        }
        
        if let page = page {
            updatePageLabel(with: page)
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
