//
//  MediaImage.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//

import Foundation

public struct MediaImage: Decodable {
    private enum CodingKeys: String, CodingKey {
        case mediumImage = "medium"
    }
    public var mediumImage: String
}
