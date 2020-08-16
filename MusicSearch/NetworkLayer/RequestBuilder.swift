//
//  RequestBuilder.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 15/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

class RequestBuilder {
    public class func buildURLRequest(endPoint: RequestEndPoint) -> URLRequest? {
        
        var components = URLComponents()
        components.scheme = endPoint.scheme
        components.host = endPoint.host
        components.queryItems = endPoint.parameters
        if let path = endPoint.path { components.path = path }

        // URLRequest
        guard let url = components.url else { return nil }
        var urlRequest = URLRequest(url: URL(string: "https://ws.audioscrobbler.com/2.0/?method=artist.gettoptracks&artist=cher&api_key=3e993d0279bd62c8160982392010f7bf&format=json") ?? url)
        urlRequest.httpMethod = endPoint.method
        
        return urlRequest
    }
}
