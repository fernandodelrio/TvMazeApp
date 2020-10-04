//
//  MediaTableViewCell.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import Core
import PromiseKit
import UIKit

// This table view cell, is re-used on many table views of the app
// it can display image + text and optionally a favorite button
class MediaTableViewCell: UITableViewCell {
    var viewModel = MediaTableViewCellViewModel()
    @IBOutlet weak var mediaImageView: AsyncImageView?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var favoriteButton: UIButton?

    @IBAction private func didTapFavoriteButton(_ sender: Any) {
        viewModel.favorite()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupBindings()
    }

    private func setupBindings() {
        viewModel.onFavoritedChange = { [weak self] isFavorited in
            self?.setFavoriteButtonState(isFavorited: isFavorited)
        }
        viewModel.onFavoriteEnabledChange = { [weak self] isFavoriteEnabled in
            self?.favoriteButton?.isHidden = !isFavoriteEnabled
        }
    }

    // Change the image on the favorite button
    private func setFavoriteButtonState(isFavorited: Bool) {
        let image = isFavorited ? AppConstants.starFilledImage : AppConstants.starImage
        favoriteButton?.setBackgroundImage(image, for: .normal)
    }
}
