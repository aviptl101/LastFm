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
        Configuration.shared.configure(apiKey: Constants.apiKey)

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
        // Arrange
        let expectation = XCTestExpectation(description: "getTracks")
        let artist = Constants.initialSearch
        let sut = createSUT()

        // Act
        sut.dataSource.trackSearchViewModel.getTopTracks(artist: artist, page: 1, autocorrect: false) { result in
            expectation.fulfill()

            switch result {
            case .success(let value):
                if let cellModels = value {
                    // Assert
                    sut.dataSource.trackCellModels = cellModels
                    XCTAssertEqual(sut.dataSource.tracksCount, Constants.itemsPerPage, "Initially viewModel's tracksCount should be same as fixed items per page")
                    XCTAssertEqual(sut.dataSource.tracksCount, sut.dataSource.trackSearchViewModel.allTopTracks.count, "viewModel's tracksCount should be same as allTopTracks array's count")
                     XCTAssertEqual(sut.dataSource.trackSearchViewModel.lastSearchedArtist, Constants.initialSearch, "Initially iewModel's last searched artist should be Constants.initialSearch")
                } else {
                    XCTFail("cellModels should not be nil")
                }
            case .failure(let error):
                print(error)
                XCTFail("Initial search should not give error")
            }
        }
            
        wait(for: [expectation], timeout: 20)
    }
    
    func testUpdatePageLabel() {
        // Arrange
        let sut = createSUT()
        let page = 4
        let pageStr = String("Page: \(page)")
        
        // Act
        sut.updatePageLabel(with: page)
        
        // Assert
        XCTAssertEqual(sut.pageLabel.text, pageStr, "ViewController should update exact page value to the Page label")
    }
    
    func testLoadNextPageTracks() {
        // Arrange
        let sut = createSUT()
        let viewModel = sut.dataSource.trackSearchViewModel
        let pageIndex = viewModel.currentPageIndex
        
        // Act
        sut.dataSource.loadNextPageTracks()
        
        // Assert
        XCTAssertEqual(viewModel.currentPageIndex, pageIndex + 1, "ViewModel's currentPageIndex should be equal to previous pageIndex + 1")
    }
    
    func testReloadPageTracks() {
        // Arrange
        let expectation = XCTestExpectation(description: "loadNextPageTracks")
        let sut = createSUT()
        let viewModel = sut.dataSource.trackSearchViewModel
        let pageIndex = viewModel.currentPageIndex
        
        // Act
        viewModel.reloadPage() { result in
            expectation.fulfill()

            switch result {
            case .success:
                // Assert
                XCTAssertEqual(viewModel.currentPageIndex, pageIndex, "ViewModel's currentPageIndex should be equal to previous pageIndex after reloading page")
            case .failure(let error):
                print(error)
                XCTFail("Initial search should not give error")
            }
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
        let artist = Constants.initialSearch
        let sut = createSUT()
        let cell = sut.tableView.dequeueReusableCell(withIdentifier: Constants.SearchCellIdentifier) as! TrackSearchCell
        
        // Act
        XCTAssertNotNil(cell, "TableView should be able to dequeue cell with Constants.SearchCellIdentifier")
        sut.dataSource.trackSearchViewModel.getTopTracks(artist: artist, page: 1, autocorrect: false) { result in
            expectation.fulfill()

            switch result {
            case .success(let value):
                if let cellModels = value {
                    let cellModel = cellModels[0]
                    cell.setTrackInfo(trackCellModel: cellModel)
                    // Assert
                    XCTAssertEqual(cell.artistLabel.text, sut.dataSource.trackSearchViewModel.lastSearchedArtist, "After searching, cell's artist label text should match with viewModel's lastSearchedArtist")
                } else {
                    XCTFail("cellModels should not be nil")
                }
            case .failure(let error):
                print(error)
                XCTFail("Search should not give error")
            }
        }
        
        wait(for: [expectation], timeout: 20)
    }
}
