//
//  ShowDetailViewController.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/2/20.
//

import UIKit

class ShowDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var mediaImageView: AsyncImageView?
    @IBOutlet weak var favoriteButton: UIButton?
    @IBOutlet weak var scheduleLabel: UILabel?
    @IBOutlet weak var genresLabel: UILabel?
    @IBOutlet weak var summaryTextView: UITextView?
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var summaryTextViewHeight: NSLayoutConstraint?
    
    var viewModel = ShowDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.screenType.isSmallScreen {
            summaryTextViewHeight?.constant = 50
        } else {
            summaryTextViewHeight?.constant = 120
        }
        summaryTextView?.textContainerInset = .zero
        summaryTextView?.textContainer.lineFragmentPadding = 0
        viewModel.onLoadingChange = { [weak self] isLoading in
            self?.nameLabel?.isHidden = isLoading
            self?.mediaImageView?.isHidden = isLoading
            self?.favoriteButton?.isHidden = isLoading
            self?.scheduleLabel?.isHidden = isLoading
            self?.genresLabel?.isHidden = isLoading
            self?.summaryTextView?.isHidden = isLoading
            self?.tableView?.isHidden = isLoading
            isLoading ? self?.view.showLoading() : self?.view.hideLoading()
        }
        
        viewModel.onFavoriteChange = { [weak self] isFavorited in
            self?.setFavoriteButtonState(isFavorited: isFavorited)
        }

        viewModel.onDataChange = { [weak self] in
            self?.nameLabel?.text = self?.viewModel.show?.name
            self?.mediaImageView?.loadImage(self?.viewModel.show?.poster)
            let time = self?.viewModel.show?.schedule.time ?? ""
            let days = self?.viewModel.show?.schedule.days.joined(separator: ", ") ?? ""
            if time.isEmpty, days.isEmpty {
                self?.scheduleLabel?.text = "No schedule available."
            } else if !time.isEmpty, days.isEmpty {
                self?.scheduleLabel?.text = "At \(time)."
            } else if time.isEmpty, !days.isEmpty {
                self?.scheduleLabel?.text = "On \(days)."
            } else {
                self?.scheduleLabel?.text = "At \(time) on \(days)."
            }
            if let genres = self?.viewModel.show?.genres, !genres.isEmpty {
                self?.genresLabel?.text = genres.joined(separator: ", ")
            } else {
                self?.genresLabel?.text = "No genres available."
            }
            if let summary = self?.viewModel.show?.summary, !summary.isEmpty {
                self?.summaryTextView?.text = summary
            } else {
                self?.summaryTextView?.text = "No summary available."
            }
            let isFavorited = self?.viewModel.isFavorited ?? false
            self?.setFavoriteButtonState(isFavorited: isFavorited)
            self?.tableView?.reloadData()
        }
        viewModel.load()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.appear()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? EpisodeDetailViewController
        let indexPath = viewModel.selectedIndexPathForNavigation
        let episode = viewModel.show?.episodesBySeason[indexPath.section]?[indexPath.row]
        destination?.viewModel.episode = episode
    }

    @IBAction func didTapFavoriteButton(_ sender: Any) {
        viewModel.favorite()
    }

    func loadImages() {
        tableView?.indexPathsForVisibleRows?.forEach {
            let episode = viewModel.show?.episodesBySeason[$0.section]?[$0.row]
            let cell = tableView?.cellForRow(at: $0) as? MediaTableViewCell
            cell?.mediaImageView?.loadImage(episode?.image)
        }
    }

    private func setFavoriteButtonState(isFavorited: Bool) {
        let image = isFavorited ? UIImage(named: "star-filled") : UIImage(named: "star")
        favoriteButton?.setBackgroundImage(image, for: .normal)
        favoriteButton?.reloadInputViews()
    }
}

extension ShowDetailViewController: UITableViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        loadImages()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImages()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedIndexPathForNavigation = indexPath
        performSegue(withIdentifier: "episodeListToDetailSegue", sender: nil)
    }
}

extension ShowDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.show?.episodesBySeason.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Season \(section+1)"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.show?.episodesBySeason[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showDetailsCell", for: indexPath) as? MediaTableViewCell
        let episode = viewModel.show?.episodesBySeason[indexPath.section]?[indexPath.row]
        cell?.isFavoriteEnabled = false
        if tableView.isDragging || tableView.isDecelerating {
            cell?.mediaImageView?.setPlaceholder()
        } else {
            cell?.mediaImageView?.loadImage(episode?.image)
        }
        cell?.descriptionLabel?.text = episode?.name ?? ""
        return cell ?? UITableViewCell()
    }
}
