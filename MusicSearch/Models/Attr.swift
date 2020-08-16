//
//  Attr.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 16/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

public struct Attr: Codable {
    public let user: String?
    public let page: String
    public let perPage: String
    public let totalPages: String
    public let total: String

    enum CodingKeys: String, CodingKey {
        case user
        case page
        case perPage
        case totalPages
        case total
    }
}
