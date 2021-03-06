//
//  String+DecodingEncoding.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//

import Foundation

public extension String {
    // Decoded HTML strings removing tags
    var htmlDecoded: String {
        guard let stringData = data(using: .utf8) else {
            return ""
        }
        let attributedString = try? NSAttributedString(
            data: stringData,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )
        return attributedString?.string ?? ""
    }

    // Encode URL strings, adding percent encoding
    var urlEncoded: String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }
}
