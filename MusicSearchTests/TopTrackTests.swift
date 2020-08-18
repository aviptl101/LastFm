//
//  TopTrackTests.swift
//  MusicSearchTests
//
//  Created by Avinash J Patel on 18/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import XCTest
@testable import MusicSearch

class TopTrackTests: XCTestCase {
    
    private enum Constants {
        static let trackName = "holi holi"
        static let artistName = "DJ Snake"
        static let listeners = "234234"
        static let playcount = "34212"
        static let streamable = "false"
    }
    
    var topTrack: TopTrack!
    var artist: ArtistMock!
    
    override func setUpWithError() throws {
        artist = ArtistMock(name: Constants.artistName)
        topTrack = TopTrack.createTopTrack(name: Constants.trackName, listeners: Constants.listeners, playcount: Constants.playcount, streamable: Constants.streamable, artist: artist)
    }

    override func tearDownWithError() throws {
        artist = nil
        topTrack = nil
    }
    
    func testInit() {
        XCTAssertEqual(topTrack.name, Constants.trackName)
        XCTAssertEqual(topTrack.listeners, Constants.listeners)
        XCTAssertEqual(topTrack.playcount, Constants.playcount)
        XCTAssertEqual(topTrack.streamable, Constants.streamable)
        
        XCTAssertEqual(artist.name, Constants.artistName)
        XCTAssertEqual(topTrack.artist?.name, artist.name)
    }
}
