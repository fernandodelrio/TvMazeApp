//
//  EpisodeDetailViewController.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/2/20.
//

import UIKit

class EpisodeDetailViewController: UIViewController {
    var viewModel = EpisodeDetailViewModel()
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var mediaImageView: AsyncImageView?
    @IBOutlet weak var episodeLabel: UILabel?
    @IBOutlet weak var summaryLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Episode details".localized
        // The episode should be available already,
        // just display in the UI
        nameLabel?.text = viewModel.episode?.name
        // The image still loads asynchronously
        mediaImageView?.loadImage(viewModel.episode?.image)
        let season = viewModel.episode?.season ?? 0
        let episode = viewModel.episode?.number ?? 0
        episodeLabel?.text = "Season %1$d episode %2$d.".localizedWith(season, episode)
        let summary = viewModel.episode?.summary ?? ""
        if summary.isEmpty {
            summaryLabel?.text = "No summary available.".localized
        } else {
            summaryLabel?.text = viewModel.episode?.summary ?? ""
        }
    }
}
