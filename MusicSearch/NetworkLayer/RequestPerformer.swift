//
//  RequestPerformer.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 15/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

public enum SessionTaskError: Error {
    /// Error for `URLSession`.
    case connectionError(Error?)

    /// Error while creating `URLReqeust`.
    case requestError

    /// Error while creating `Response`.
    case responseError(Error?)
}

class RequestPerformer {
    static func request<T: Codable>(urlRequest: URLRequest, completion: @escaping (Result<T, SessionTaskError>) -> ()) {
        
        // URLSession
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            
            switch (data, response, error) {
            case (_, _, let error?):
                completion(.failure(.connectionError(error)))

            case (let data, let response as HTTPURLResponse, _):
                do {
                    guard let responseData = data else {
                        completion(.failure(.responseError(error)))
                        return
                    }
                    let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String : [String : Any]]
                    print(json ?? "errorrrrrrrr")
                    
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(T.self, from: responseData)
                    print(responseObject)
                    DispatchQueue.main.async {
                        // CallBack Completion
                        completion(.success(responseObject))
                    }
                } catch {
                    print(error)
                    completion(.failure(.responseError(error)))
                }
            default:
                completion(.failure(.responseError(error!)))
            }
        }
        dataTask.resume()
    }
}
