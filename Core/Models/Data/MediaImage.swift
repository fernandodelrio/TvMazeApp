//
//  MediaImage.swift
//  TvMaze
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//  Copyright © 2020 Fernando Henrique Bonfim Moreno Del Rio. All rights reserved.
//

import Foundation

public struct MediaImage: Decodable {
    private enum CodingKeys: String, CodingKey {
        case mediumImage = "medium"
    }
    public var mediumImage: String
}
