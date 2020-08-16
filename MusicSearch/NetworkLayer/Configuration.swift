//
//  Configuration.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 15/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

// API Key Configuration for Lastfm
public class Configuration {
    public static let shared = Configuration()
    private init() { }

    public var apiKey: String?

    public func configure(apiKey: String) {
        self.apiKey = apiKey
    }
}
