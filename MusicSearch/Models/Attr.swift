//
//  Attr.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 16/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

struct Attr: Codable {
    let user: String?
    let page: String
    let perPage: String
    let totalPages: String
    let total: String

    enum CodingKeys: String, CodingKey {
        case user
        case page
        case perPage
        case totalPages
        case total
    }
}
