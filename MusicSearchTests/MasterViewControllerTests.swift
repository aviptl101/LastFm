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
    
    func testProperties() {
        let sut = createSUT()
        XCTAssertNotNil(dataSource, "dataSource shouldn't be nil")
        XCTAssertTrue(dataSource.delegate === sut)
    }
    
    func testTableViewHasCells() {
        let sut = createSUT()
        let cell = sut.tableView.dequeueReusableCell(withIdentifier: Constants.SearchCellIdentifier)

        XCTAssertNotNil(cell, "TableView should be able to dequeue cell with Constants.SearchCellIdentifier")
    }
    
    func testInitialGetTopTracks() {
        let expectation = XCTestExpectation(description: "getTracks")
        let sut = createSUT()

        sut.dataSource.getSearchData {
            expectation.fulfill()
            XCTAssertEqual(sut.dataSource.trackSearchViewModel.lastSearchedArtist, Constants.initialSearch)
            XCTAssertEqual(sut.dataSource.trackSearchViewModel.tracksCount, Constants.itemsPerPage)
            XCTAssertEqual(sut.dataSource.trackSearchViewModel.tracksCount, sut.dataSource.trackSearchViewModel.allTopTracks.count)
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testDataSourceTracksCount() {
        let expectation = XCTestExpectation(description: "getTracks")
        let sut = createSUT()

        sut.dataSource.getSearchData {
            expectation.fulfill()
            XCTAssertEqual(sut.dataSource.trackSearchViewModel.tracksCount, sut.dataSource.tracksCount)
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testSearchArtistToGetTracks() {
        let expectation = XCTestExpectation(description: "searchArtistTracks")
        let artist = "taylor"
        let sut = createSUT()
        
        sut.dataSource.searchArtist(artist) {
            expectation.fulfill()
            XCTAssertEqual(sut.dataSource.trackSearchViewModel.lastSearchedArtist, artist)
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testEmptySearchToGetTracks() {
        let expectation = XCTestExpectation(description: "emptySearchArtistTracks")
        let artist = ""
        let sut = createSUT()
        
        sut.dataSource.searchArtist(artist) {
            expectation.fulfill()
            XCTAssertNotEqual(sut.dataSource.trackSearchViewModel.lastSearchedArtist, artist, "If empty Search string then it shouldn't search and lastSearchedArtist should not change to empty string")
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testLoadNextPageTracks() {
        let expectation = XCTestExpectation(description: "loadNextPageTracks")
        let sut = createSUT()
        let viewModel = sut.dataSource.trackSearchViewModel
        let pageIndex = viewModel.currentPageIndex
        
        viewModel.loadNextPageTracks {
            expectation.fulfill()
            XCTAssertEqual(viewModel.currentPageIndex, pageIndex + 1, "ViewModel's currentPageIndex should be equal to previous pageIndex + 1")
        }
        
        wait(for: [expectation], timeout: 20)
    }
}
