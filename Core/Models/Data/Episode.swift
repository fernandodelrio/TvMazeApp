//
//  Episode.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//

import Foundation

public struct Episode: Decodable {
    private enum CodingKeys: CodingKey {
        case id
        case name
        case number
        case season
        case summary
        case image
    }
    public var id: Int
    public var name: String
    public var number: Int
    public var season: Int
    public var summary: String?
    public var image: URL?

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        number = try values.decode(Int.self, forKey: .number)
        let seasonNumber = try values.decode(Int.self, forKey: .season)
        // Making sure, the season number starts on zero
        // this helps to split the episodes into seasons
        // and display properly in the UI later
        season = max(seasonNumber-1, 0)
        let rawSummary = try values.decode(String?.self, forKey: .summary)
        // The summary come with some HTML tags, so just decode it
        summary = rawSummary?.htmlDecoded
        let mediaImage = try values.decode(MediaImage?.self, forKey: .image)
        // Using medium images, to improve mobile performance
        image = URL(string: mediaImage?.mediumImage ?? "")
    }
}
