//
//  Show.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//

import Foundation

public struct Show: Decodable {
    private enum CodingKeys: CodingKey {
        case id
        case name
        case image
        case schedule
        case genres
        case summary
    }

    public var id: Int
    public var name: String
    public var poster: URL?
    public var schedule: Schedule
    public var genres: [String]
    public var summary: String?
    public var episodesBySeason: [Int: [Episode]] = [:]
    public var seasonKeys: [Int] {
        episodesBySeason.keys.sorted()
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        let mediaImage = try values.decode(MediaImage?.self, forKey: .image)
        // Using medium images, to improve mobile performance
        poster = URL(string: mediaImage?.mediumImage ?? "")
        schedule = try values.decode(Schedule.self, forKey: .schedule)
        genres = try values.decode([String].self, forKey: .genres)
        let rawSummary = try values.decode(String?.self, forKey: .summary)
        // The summary come with some HTML tags, so just decode it
        summary = rawSummary?.htmlDecoded
    }

    public init() {
        id = 0
        name = ""
        poster = nil
        schedule = Schedule(time: "", days: [])
        genres = []
        summary = nil
        episodesBySeason = [:]
    }
}
