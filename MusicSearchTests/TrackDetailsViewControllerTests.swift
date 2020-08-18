//
//  TrackDetailsViewControllerTests.swift
//  MusicSearchTests
//
//  Created by Avinash J Patel on 18/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import XCTest
@testable import MusicSearch

class TrackDetailsViewControllerTests: XCTestCase {
    private enum Constants {
        static let trackName = "holi holi"
        static let artistName = "DJ Snake"
        static let listeners = "234234"
        static let playcount = "34212"
        static let streamable = "false"
    }
    
    var trackDetailsVC: TrackDetailsViewController!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        trackDetailsVC = storyboard.instantiateViewController(withIdentifier: "TrackDetailsVC") as? TrackDetailsViewController
        trackDetailsVC.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        trackDetailsVC = nil
    }
    
    func testViewConfiguration() {
        // Given
        let artist = ArtistMock(name: Constants.artistName)
        let topTrack = TopTrack.createTopTrack(name: Constants.trackName, listeners: Constants.listeners, playcount: Constants.playcount, streamable: Constants.streamable, artist: artist)
        
        // When
        trackDetailsVC.configureViewWithTrackInfor(trackInfo: topTrack)
        
        // Then
        XCTAssertEqual(trackDetailsVC.titleLabel.text, Constants.trackName)
        XCTAssertEqual(trackDetailsVC.artistLabel.text, Constants.artistName)
        XCTAssertEqual(trackDetailsVC.listenersLabel.text, Constants.listeners)
        XCTAssertEqual(trackDetailsVC.playCountLabel.text, Constants.playcount)
        XCTAssertNotEqual(trackDetailsVC.titleLabel.text, "ABCD")
    }
}
