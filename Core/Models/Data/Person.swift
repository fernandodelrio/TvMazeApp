//
//  Person.swift
//  TvMaze
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//  Copyright © 2020 Fernando Henrique Bonfim Moreno Del Rio. All rights reserved.
//

import Foundation

public struct Person: Decodable {
    private enum CodingKeys: CodingKey {
        case person
    }

    private struct PersonData: Decodable {
        private enum CodingKeys: CodingKey {
            case id
            case name
            case image
        }

        var id: Int
        var name: String
        var image: URL?
        var shows: [Show] = []

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decode(Int.self, forKey: .id)
            name = try values.decode(String.self, forKey: .name)
            let mediaImage = try? values.decode(MediaImage.self, forKey: .image)
            image = URL(string: mediaImage?.mediumImage ?? "")
        }
    }

    public var id: Int
    public var name: String
    public var image: URL?
    public var shows: [Show]

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let personData = try values.decode(PersonData.self, forKey: .person)
        id = personData.id
        name = personData.name
        image = personData.image
        shows = personData.shows
    }
}
