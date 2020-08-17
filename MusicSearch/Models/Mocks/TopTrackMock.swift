//
//  TopTrackMock.swift
//  MusicSearchTests
//
//  Created by Avinash J Patel on 18/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

struct TopTracksResponseMock: Encodable {
    let list: [TopTrackMock]
    let attr: AttrMock
    init(list: [TopTrackMock] = [TopTrackMock](), attr: AttrMock = AttrMock()) {
        self.list = list
        self.attr = attr
    }
}

struct TopTrackMock: Encodable {
    let name: String
    let listeners: String
    let playcount: String
    var mbid: String?
    let url: URL?
    let streamable: String
    var artist: ArtistMock?
    let image: [ImageMock]
    let rank: String
    
    init(name: String = "tuhi", listeners: String = "234231", playcount: String = "12312", mbid: String? = "mbid", url: URL? = URL(string: "url"), streamable: String = "false", artist: ArtistMock? = ArtistMock(), image: [ImageMock] = [ImageMock](), rank: String = "1") {
        self.name = name
        self.listeners = listeners
        self.playcount = playcount
        self.mbid = mbid
        self.url = url
        self.streamable = streamable
        self.artist = artist
        self.image = image
        self.rank = rank
    }
}

struct ImageMock: Encodable {
    var url: URL?
    private let text: String
    private let size: String
    
    init(url: URL? = URL(string: "url"), text: String = "text", size: String = "size") {
        self.url = url
        self.text = text
        self.size = size
    }
}

struct ArtistMock: Encodable {
    let name: String
    var mbid: String?
    var url: URL?
    
    init(name: String = "Taylor", mbid: String = "fw8er-sdf8ew-wfwe", url: URL? = URL(string: "url")) {
        self.name = name
        self.mbid = mbid
        self.url = url
    }
}
