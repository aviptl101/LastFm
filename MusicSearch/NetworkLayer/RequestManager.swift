//
//  RequestManager.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 15/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

typealias Response = Result<TopTracksResponse, SessionTaskError>

class RequestManager {
    static func getTopTracks(endPoint: RequestEndPoint, completion: @escaping (Response) -> Void) {
        // URLRequest
        guard let request = RequestBuilder.buildURLRequest(endPoint: endPoint) else {
            completion(.failure(.requestError))
            return
        }
        RequestPerformer.request(urlRequest: request) { (result: Response) in
            completion(result)
        }
    }
}
