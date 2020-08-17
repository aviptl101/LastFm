//
//  RequestPerformer.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 15/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

enum SessionTaskError: Error {
    /// Error for 'URLSession'.
    case connectionError

    /// Error while creating 'URLReqeust'.
    case requestError

    /// Error while creating 'Response'.
    case responseError
    
    var errorMessage: String {
        switch self {
        case .connectionError:
            return "Operation Failed. Network Error. Try Later"
        case .requestError:
            return "Operation Failed. Improper Request"
        case .responseError:
            return "Operation Failed. Response is not in proper format"
        }
    }
}

class RequestPerformer {
    static func request<T: Codable>(urlRequest: URLRequest, completion: @escaping (Result<T, SessionTaskError>) -> ()) {
        
        // URLSession
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            
            switch (data, response, error) {
            case (_, _, let error?):
                print(error)
                completion(.failure(.connectionError))

            case (let data, _, _):
                do {
                    guard let responseData = data else {
                        completion(.failure(.responseError))
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(T.self, from: responseData)
                    DispatchQueue.main.async {
                        // CallBack Completion
                        completion(.success(responseObject))
                    }
                } catch {
                    print(error)
                    completion(.failure(.responseError))
                }
            }
        }
        dataTask.resume()
    }
}
