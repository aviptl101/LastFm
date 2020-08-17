//
//  AttrMock.swift
//  MusicSearchTests
//
//  Created by Avinash J Patel on 18/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

struct AttrMock: Encodable {
    let user: String?
    let page: String
    let perPage: String
    let totalPages: String
    let total: String
    init(user: String? = "user", page: String = "34", perPage: String = "50", totalPages: String = "123", total: String = "123432") {
        self.user = user
        self.page = page
        self.perPage = perPage
        self.totalPages = totalPages
        self.total = total
    }
}
