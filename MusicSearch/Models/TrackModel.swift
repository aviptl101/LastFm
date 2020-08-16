//
//  TrackModel.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 16/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

struct Tag: Codable {
    let name: String
    let url: URL
}

struct Wiki: Codable {
    let published: String
    let summary: String
    let content: String
}

struct Album: Codable {
    let artist: String
    let title: String
    let mbid: String?
    let url: URL
    var image: Image?
    let position: Int?

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

struct TrackInfo: Codable {
    let name: String
    let url: URL
    var duration: Int?
    let streamable: String
    let listeners: String
    let playcount: String
    var artist: Artist?
    var toptags: [Tag]?

    var mbid: String?
    var album: Album?
    var userplaycount: Int?
    var userloved: Bool?
    var wiki: Wiki?

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
