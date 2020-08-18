//
//  TopTrack.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 16/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

struct TopTracksResponse: Codable {
    let list: [TopTrack]
    let attr: Attr

    private enum CodingKeys: String, CodingKey {
        case list
        case attr
    }

    private enum TopTracksKeys: String, CodingKey {
        case toptracks
    }

    private enum TrackAttrKeys: String, CodingKey {
        case track
        case attr = "@attr"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: TopTracksKeys.self)
        let recentTracks = try values.nestedContainer(keyedBy: TrackAttrKeys.self, forKey: .toptracks)
        self.attr = try recentTracks.decode(Attr.self, forKey: .attr)
        self.list = try recentTracks.decode([TopTrack].self, forKey: .track)
    }
}

struct TopTrack: Codable {
    let name: String
    let listeners: String
    let playcount: String
    var mbid: String?
    let url: URL?
    let streamable: String
    var artist: Artist?
    let image: [Image]
    let rank: String?

    private enum CodingKeys: String, CodingKey {
        case name
        case listeners
        case playcount
        case mbid
        case url
        case streamable
        case artist
        case image
        case rank = "@attr"
    }
    
    private enum RankKeys: String, CodingKey {
        case rank
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        listeners = try container.decode(String.self, forKey: .listeners)
        playcount = try container.decode(String.self, forKey: .playcount)
        if container.allKeys.contains(CodingKeys.mbid) {
            mbid = try container.decode(String.self, forKey: .mbid)
        }
        url = try? container.decode(URL.self, forKey: .url)
        streamable = try container.decode(String.self, forKey: .streamable)
        artist = try container.decode(Artist.self, forKey: .artist)
        image = try container.decode([Image].self, forKey: .image)
        let rankContainer = try? container.nestedContainer(keyedBy: RankKeys.self, forKey: .rank)
        rank = try rankContainer?.decode(String.self, forKey: .rank)
    }
}

struct Image: Codable {
    var url: URL?
    private let text: String
    private let size: String
    
    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        size = try container.decode(String.self, forKey: .size)
        url = URL(string: text)
    }
}

struct Artist: Codable {
    let name: String
    var mbid: String?
    var url: URL?

    private enum CodingKeys: String, CodingKey {
        case name
        case mbid
        case url
    }
}
