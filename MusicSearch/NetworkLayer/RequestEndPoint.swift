//
//  RequestEndPoint.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 15/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

enum RequestEndPoint {
    case getTrackInfo(mbid: String? = nil, track: String? = nil, artist: String? = nil, username: String? = nil, autocorrect: Bool = false)
    
    public var scheme: String {
        return "https"
    }
    
    public var method: String {
        switch self {
        case .getTrackInfo:
            return "GET"
        }
    }
    
    public var host: String {
        return "ws.audioscrobbler.com/2.0"
    }
    
    public var path: String? {
        switch self {
        case .getTrackInfo:
            return nil
        }
    }
    
    public var parameters: [URLQueryItem] {
        switch self {
        case .getTrackInfo(let mbid, let track, let artist, let username, let autocorrect):
            
            var query = [URLQueryItem]()
            if let mbid = mbid { query.append(URLQueryItem(name: "mbid", value: mbid)) }
            if let track = track { query.append(URLQueryItem(name: "track", value: track)) }
            if let artist = artist { query.append(URLQueryItem(name: "artist", value: artist)) }
            if let username = username { query.append(URLQueryItem(name: "username", value: username)) }
            query.append(URLQueryItem(name: "autocorrect", value: autocorrect ? "1" : "0"))
            query.append(URLQueryItem(name: "format", value: "json"))
            query.append(URLQueryItem(name: "api_key", value: Configuration.shared.apiKey ?? ""))

            return query
            
        default:
            return []
        }
    }
}
