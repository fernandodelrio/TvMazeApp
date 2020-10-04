//
//  ShowDetailViewController.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/2/20.
//

import Core
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
        setupScreenForSpecificDevices()
        setupTextView()
        setupBindings()
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

    // When the table view stops scrolling,
    // this will load the images. This helps
    // to avoid the flickering of
    // async + cell reuse
    private func loadImages() {
        tableView?.indexPathsForVisibleRows?.forEach {
            let episode = viewModel.show?.episodesBySeason[$0.section]?[$0.row]
            let cell = tableView?.cellForRow(at: $0) as? MediaTableViewCell
            cell?.mediaImageView?.loadImage(episode?.image)
        }
    }

    private func setupBindings() {
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
            // Setup the schedule. Fallback for when there's no days info
            // or when there's no time info. Or when both are missing
            if time.isEmpty, days.isEmpty {
                self?.scheduleLabel?.text = "No schedule available."
            } else if !time.isEmpty, days.isEmpty {
                self?.scheduleLabel?.text = "At \(time)."
            } else if time.isEmpty, !days.isEmpty {
                self?.scheduleLabel?.text = "On \(days)."
            } else {
                self?.scheduleLabel?.text = "At \(time) on \(days)."
            }
            // Setup the genres. Fallback for when there's no genres
            if let genres = self?.viewModel.show?.genres, !genres.isEmpty {
                self?.genresLabel?.text = genres.joined(separator: ", ")
            } else {
                self?.genresLabel?.text = "No genres available."
            }
            // Setup the summary. Fallback for when there's no summary
            if let summary = self?.viewModel.show?.summary, !summary.isEmpty {
                self?.summaryTextView?.text = summary
            } else {
                self?.summaryTextView?.text = "No summary available."
            }
            let isFavorited = self?.viewModel.isFavorited ?? false
            self?.setFavoriteButtonState(isFavorited: isFavorited)
            self?.tableView?.reloadData()
        }
    }

    // Set the favorite button image
    private func setFavoriteButtonState(isFavorited: Bool) {
        let image = isFavorited ? UIImage(named: "star-filled") : UIImage(named: "star")
        favoriteButton?.setBackgroundImage(image, for: .normal)
        favoriteButton?.reloadInputViews()
    }

    // On devices with smaller screens,
    // decrease the height of the summary,
    // so the table view won't cut
    private func setupScreenForSpecificDevices() {
        if UIDevice.screenType.isSmallScreen {
            summaryTextViewHeight?.constant = AppConstants.smallSummarySize
        } else {
            summaryTextViewHeight?.constant = AppConstants.bigSummarySize
        }
    }

    // Removes the padding from text view
    private func setupTextView() {
        summaryTextView?.textContainerInset = .zero
        summaryTextView?.textContainer.lineFragmentPadding = 0
    }
}

extension ShowDetailViewController: UITableViewDelegate {
    // These scroll view methods are called indicating
    // the user is not scrolling the table view
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        loadImages()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImages()
    }

    // Navigate to episode details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedIndexPathForNavigation = indexPath
        performSegue(withIdentifier: "episodeListToDetailSegue", sender: nil)
    }
}

extension ShowDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.show?.episodesBySeason.count ?? 0
    }

    // Each section represents a season
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Season \(section+1)"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.show?.episodesBySeason[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showDetailsCell", for: indexPath) as? MediaTableViewCell
        let episode = viewModel.show?.episodesBySeason[indexPath.section]?[indexPath.row]
        // Make sure to hide the favorite button
        // as this is a cell for an episode
        cell?.viewModel.isFavoriteEnabled = false
        // If the table view is scrolling, set a placeholder
        // Otherwise, loads the image asynchronously
        if tableView.isDragging || tableView.isDecelerating {
            cell?.mediaImageView?.setPlaceholder()
        } else {
            cell?.mediaImageView?.loadImage(episode?.image)
        }
        cell?.descriptionLabel?.text = episode?.name ?? ""
        return cell ?? UITableViewCell()
    }
}
