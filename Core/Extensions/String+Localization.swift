//
//  String+Localization.swift
//  Core
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/4/20.
//

import Foundation

public extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    func localizedWith(_ args: CVarArg...) -> String {
        String(format: localized, arguments: args)
    }
}
