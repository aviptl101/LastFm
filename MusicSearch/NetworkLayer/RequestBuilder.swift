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
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endPoint.method
        
        return urlRequest
    }
}
