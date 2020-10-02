//
//  String+DecodingEncoding.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//  Copyright © 2020 Fernando Henrique Bonfim Moreno Del Rio. All rights reserved.
//

import Foundation

public extension String {
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
    
    var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? self
    }
}
