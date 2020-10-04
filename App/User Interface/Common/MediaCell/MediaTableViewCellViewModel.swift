//
//  MediaTableViewCellViewModel.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/3/20.
//

import Foundation

class MediaTableViewCellViewModel {
    var isFavoriteEnabled = false {
        didSet {
            onFavoriteEnabledChange?(isFavoriteEnabled)
        }
    }
    var isFavorited = false {
        didSet {
            onFavoritedChange?(isFavorited)
        }
    }
    var onFavoritedChange: ((_ isFavorited: Bool) -> Void)?
    var onFavoriteEnabledChange: ((_ isFavorited: Bool) -> Void)?
    var onFavoriteTap: (() -> Void)?

    // When favorited, toggle the flag
    // and notify back other views with
    // onFavoriteTap
    func favorite() {
        isFavorited.toggle()
        onFavoriteTap?()
    }
}
