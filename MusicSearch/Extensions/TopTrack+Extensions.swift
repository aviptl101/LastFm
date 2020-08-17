//
//  TopTrack+Extensions.swift
//  MusicSearch
//
//  Created by Avinash J Patel on 18/08/20.
//  Copyright © 2020 Avinash. All rights reserved.
//

import Foundation

extension TopTrack {
    static func createTopTrack(
        name: String = "Holy",
        listeners: String = "23421",
        playcount: String = "1233",
        mbid: String? = "fw8er-sdf8ew-wfwe",
        url: URL? = URL(string: ""),
        streamable: String = "0",
        artist: ArtistMock? = ArtistMock(),
        image: [ImageMock] = [ImageMock](),
        rank: String = "1") -> TopTrack? {
        let topTrackMock = TopTrackMock(
            name: name,
            listeners: listeners,
            playcount: playcount,
            mbid: mbid,
            url: url,
            streamable: streamable,
            artist: artist,
            image: image,
            rank: rank
        )
        let data = Utility.getEncoded(topTrackMock)
        return try? JSONDecoder().decode(TopTrack.self, from: data ?? Data())
    }
}

extension Artist {
    public static func createArtist(
        name: String = "Taylor",
        mbid: String = "fw8er-sdf8ew-wfwe",
        url: URL? = URL(string: "acs")) -> Artist? {
        let artistMock = ArtistMock(
            name: name,
            mbid: mbid,
            url: url
        )
        let data = Utility.getEncoded(artistMock)
        return try? JSONDecoder().decode(Artist.self, from: data ?? Data())
    }
}

extension Image {
    public static func createImage(
        url: URL? = URL(string: ""),
        text: String = "txt",
        size: String = "small") -> Image? {
        let imageMock = ImageMock(
            url: url,
            text: text,
            size: size
        )
        let data = Utility.getEncoded(imageMock)
        return try? JSONDecoder().decode(Image.self, from: data ?? Data())
    }
}
