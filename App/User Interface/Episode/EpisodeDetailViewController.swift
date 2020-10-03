//
//  EpisodeDetailViewController.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/2/20.
//

import UIKit

class EpisodeDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var mediaImageView: AsyncImageView?
    @IBOutlet weak var episodeLabel: UILabel?
    @IBOutlet weak var summaryLabel: UILabel?

    var viewModel = EpisodeDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel?.text = viewModel.episode?.name
        mediaImageView?.loadImage(viewModel.episode?.image)
        let season = (viewModel.episode?.season ?? 0) + 1
        let episode = viewModel.episode?.number ?? 0
        episodeLabel?.text = "Season \(season) episode \(episode)."
        summaryLabel?.text = viewModel.episode?.summary ?? ""
    }
}
