//
//  MasterViewControllerTests.swift
//  MusicSearchTests
//
//  Created by Avinash J Patel on 18/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import XCTest
@testable import MusicSearch

class MasterViewControllerTests: XCTestCase {
    var dataSource: TracksDataSource!

    override func setUpWithError() throws {
        super.setUp()
        let tableView = UITableView()
        dataSource = TracksDataSource(tableView: tableView)
    }

    override func tearDownWithError() throws {
        dataSource = nil
        super.tearDown()
    }
    
    func createSUT() -> MasterViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut = storyboard.instantiateViewController(withIdentifier: "MasterVC") as! MasterViewController
        sut.dataSource = dataSource
        dataSource.delegate = sut
        sut.loadViewIfNeeded()
        return sut
    }
    
    // MARK: ViewController Tests

    func testProperties() {
        let sut = createSUT()
        XCTAssertNotNil(dataSource, "dataSource shouldn't be nil")
        XCTAssertTrue(dataSource.delegate === sut)
    }
    
    func testInitialisationOfViewModelGetTopTracks() {
        let expectation = XCTestExpectation(description: "getTracks")
        let sut = createSUT()

        sut.dataSource.getSearchData {
            expectation.fulfill()
            XCTAssertEqual(sut.dataSource.trackSearchViewModel.lastSearchedArtist, Constants.initialSearch, "Initially iewModel's last searched artist should be Constants.initialSearch")
            XCTAssertEqual(sut.dataSource.trackSearchViewModel.tracksCount, Constants.itemsPerPage, "Initially viewModel's tracksCount should be same as fixed items per page")
            XCTAssertEqual(sut.dataSource.trackSearchViewModel.tracksCount, sut.dataSource.trackSearchViewModel.allTopTracks.count, "viewModel's tracksCount should be same as allTopTracks array's count")
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testDataSourceTracksCount() {
        let expectation = XCTestExpectation(description: "getTracks")
        let sut = createSUT()

        sut.dataSource.getSearchData {
            expectation.fulfill()
            XCTAssertEqual(sut.dataSource.trackSearchViewModel.tracksCount, sut.dataSource.tracksCount, "DataSource trackCount should be same as viewModel's track count")
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testSearchArtistToGetTracks() {
        // Arrange
        let expectation = XCTestExpectation(description: "searchArtistTracks")
        let artist = "taylor"
        let sut = createSUT()
        
        // Act
        sut.dataSource.searchArtist(artist) {
            expectation.fulfill()
            // Assert
            XCTAssertEqual(sut.dataSource.trackSearchViewModel.lastSearchedArtist, artist)
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testNonEmptyLastSearchedArtist() {
        // Arrange
        let expectation = XCTestExpectation(description: "emptySearchArtistTracks")
        let artist = ""
        let sut = createSUT()
        
        // Act
        sut.dataSource.searchArtist(artist) {
            expectation.fulfill()
            // Assert
            XCTAssertNotEqual(sut.dataSource.trackSearchViewModel.lastSearchedArtist, artist, "If empty Search string then it shouldn't search and lastSearchedArtist should not change to empty string")
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testLoadNextPageTracks() {
        // Arrange
        let expectation = XCTestExpectation(description: "loadNextPageTracks")
        let sut = createSUT()
        let viewModel = sut.dataSource.trackSearchViewModel
        let pageIndex = viewModel.currentPageIndex
        
        // Act
        viewModel.loadNextPageTracks {
            expectation.fulfill()
            // Assert
            XCTAssertEqual(viewModel.currentPageIndex, pageIndex + 1, "ViewModel's currentPageIndex should be equal to previous pageIndex + 1")
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    // MARK: TableCell Tests
    
    func testTableViewHasCells() {
        let sut = createSUT()
        let cell = sut.tableView.dequeueReusableCell(withIdentifier: Constants.SearchCellIdentifier) as! TrackSearchCell

        XCTAssertNotNil(cell, "TableView should be able to dequeue cell with Constants.SearchCellIdentifier")
    }
    
    func testTableViewCellArtistLabel() {
        // Arrange
        let expectation = XCTestExpectation(description: "getTracks")
        let sut = createSUT()
        let cell = sut.tableView.dequeueReusableCell(withIdentifier: Constants.SearchCellIdentifier) as! TrackSearchCell
        
        // Act
        XCTAssertNotNil(cell, "TableView should be able to dequeue cell with Constants.SearchCellIdentifier")
        sut.dataSource.getSearchData {
            expectation.fulfill()
            let cellModel = sut.dataSource.trackSearchViewModel.trackCellModels[0]
            cell.setTrackInfo(trackCellModel: cellModel)
            // Assert
            XCTAssertEqual(cell.artistLabel.text, sut.dataSource.trackSearchViewModel.lastSearchedArtist)
        }
        
        wait(for: [expectation], timeout: 20)
    }
}
