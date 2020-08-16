//
//  TrackModel.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 16/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

public struct Tag: Codable {
    public let name: String
    public let url: URL
}

public struct Wiki: Codable {
    public let published: String
    public let summary: String
    public let content: String
}

public struct Album: Codable {
    public let artist: String
    public let title: String
    public let mbid: String?
    public let url: URL
    public var image: Image?
    public let position: Int?

    private enum CodingKeys: String, CodingKey {
        case artist
        case title
        case mbid
        case url
        case image
        case position = "@attr"
    }

    private enum PositionKeys: String, CodingKey {
        case position
    }
}


private enum StreamableKeys: String, CodingKey {
    case fulltrack
}

private enum RankKeys: String, CodingKey {
    case rank
}

public struct TrackInfo: Codable {
    public let name: String
    public let url: URL
    public var duration: Int?
    public let streamable: String
    public let listeners: String
    public let playcount: String
    public var artist: Artist?
    public var toptags: [Tag]?

    public var mbid: String?
    public var album: Album?
    public var userplaycount: Int?
    public var userloved: Bool?
    public var wiki: Wiki?

    private enum CodingKeys: String, CodingKey {
        case name
        case url
        case duration
        case streamable
        case listeners
        case playcount
        case artist
        case toptags
        case mbid
        case album
        case userplaycount
        case userloved
        case wiki
    }

    private enum TrackKeys: String, CodingKey {
        case track
    }

    private enum StreamableKeys: String, CodingKey {
        case fulltrack
    }
}