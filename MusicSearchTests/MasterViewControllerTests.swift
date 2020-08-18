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
        XCTAssertNotNil(dataSource)
        XCTAssertTrue(dataSource.delegate === sut)
    }
    
    func testInitialGetTopTracks() {
        let expectation = XCTestExpectation(description: "getTracks")
        let sut = createSUT()

        sut.dataSource.getSearchData { [weak self] in
            expectation.fulfill()
            XCTAssertEqual(self?.dataSource.trackSearchViewModel.lastSearchedArtist, Constants.initialSearch)
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testSearchArtistToGetTracks() {
        let expectation = XCTestExpectation(description: "getTracks")
        let artist = "taylor"
        let sut = createSUT()
        
        sut.dataSource.searchArtist(artist) { [weak self] in
            expectation.fulfill()
            XCTAssertEqual(self?.dataSource.trackSearchViewModel.lastSearchedArtist, artist)
        }
        
        wait(for: [expectation], timeout: 20)
    }
}
