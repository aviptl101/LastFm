//
//  MusicSearchTests.swift
//  MusicSearchTests
//
//  Created by Avinash J Patel on 15/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import XCTest
@testable import MusicSearch

class MusicSearchTests: XCTestCase {
    var trackSearchViewModel: TrackSearchViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Configuration.shared.configure(apiKey: Constants.apiKey)
        trackSearchViewModel = TrackSearchViewModel(artist: Constants.initialSearch, autocorrect: false)
    }
    
    func testGetTracks() {
        let expectation = XCTestExpectation(description: "getTracks")
        let artist = "Cher"
    
        RequestManager.getTopTracks(endPoint: .getTopTracks(artist: artist, page: 1, autocorrect: false)) { (result) in
            switch result {
            case .success(let value):
                XCTAssertEqual(value.list[0].artist?.name, "Cher")
            case .failure(let error):
                XCTFail("\(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testSearchViewModelTracksCount() {
        guard let viewModel = trackSearchViewModel else {
            XCTFail("trackSearchViewModel shouldn't be nil")
            return
        }
        
        XCTAssertEqual(viewModel.tracksCount, viewModel.allTopTracks.count)
    }
    
    func testTrackSearchViewModelLoadNextPage() {
        guard let viewModel = trackSearchViewModel else {
            XCTFail("trackSearchViewModel shouldn't be nil")
            return
        }
        
        let pageIndexEarlier = viewModel.currentPageIndex + 1
        
        viewModel.loadNextPageTracks()
        
        let pageIndexLater = viewModel.currentPageIndex

        XCTAssertEqual(pageIndexEarlier, pageIndexLater)
    }
    
    func testSearchViewModelArtist() {
        guard let viewModel = trackSearchViewModel else {
            XCTFail("trackSearchViewModel shouldn't be nil")
            return
        }
        
        viewModel.getTopTracks(artist: Constants.initialSearch, page: 1, autocorrect: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            XCTAssertEqual(viewModel.lastSearchedArtist, Constants.initialSearch)
        }
    }
    
}
