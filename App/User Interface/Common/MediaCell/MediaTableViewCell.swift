//
//  MediaTableViewCell.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import Core
import PromiseKit
import UIKit

class MediaTableViewCell: UITableViewCell {
    @IBOutlet weak var mediaImageView: AsyncImageView?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var favoriteButton: UIButton?
    var onFavoriteTap: (() -> Void)?

    var isFavoriteEnabled = false {
        didSet {
            favoriteButton?.isHidden = !isFavoriteEnabled
        }
    }
    var isFavorited = false {
        didSet {
            setFavoriteButtonState(isFavorited: isFavorited)
        }
    }
    
    private func setFavoriteButtonState(isFavorited: Bool) {
        let image = isFavorited ? UIImage(named: "star.filled") : UIImage(named: "star")
        favoriteButton?.setImage(image, for: .normal)
    }
    
    @IBAction func didTapFavoriteButton(_ sender: Any) {
        isFavorited.toggle()
        onFavoriteTap?()
    }
}
