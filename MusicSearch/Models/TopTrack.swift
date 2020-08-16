//
//  TopTrack.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 16/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

public struct Image: Codable {
    public var url: URL?
    private let text: String
    private let size: String
    
    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        size = try container.decode(String.self, forKey: .size)
        url = URL(string: text)
    }
}

public struct Artist: Codable {
    public let name: String
    public var mbid: String?
    public let url: URL

    private enum CodingKeys: String, CodingKey {
        case name
        case mbid
        case url
    }
}

public struct TopTrack: Codable {
    public let name: String
    public let listeners: String
    public let playcount: String
    public var mbid: String?
    public let url: URL
    public let streamable: String
    public var artist: Artist?
    public let image: [Image]
    public let rank: String

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
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        listeners = try container.decode(String.self, forKey: .listeners)
        playcount = try container.decode(String.self, forKey: .playcount)
        if container.allKeys.contains(CodingKeys.mbid) {
            mbid = try container.decode(String.self, forKey: .mbid)
        }
        url = try container.decode(URL.self, forKey: .url)
        streamable = try container.decode(String.self, forKey: .streamable)
        artist = try container.decode(Artist.self, forKey: .artist)
        image = try container.decode([Image].self, forKey: .image)
        let rankContainer = try container.nestedContainer(keyedBy: RankKeys.self, forKey: .rank)
        rank = try rankContainer.decode(String.self, forKey: .rank)
    }
}

public struct TopTracksResponse: Codable {
    public let list: [TopTrack]
    public let attr: Attr

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

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: TopTracksKeys.self)
        let recentTracks = try values.nestedContainer(keyedBy: TrackAttrKeys.self, forKey: .toptracks)
        self.attr = try recentTracks.decode(Attr.self, forKey: .attr)
        self.list = try recentTracks.decode([TopTrack].self, forKey: .track)
    }
}
