//
//  PersonDetailViewController.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/2/20.
//

import UIKit

class PersonDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var mediaImageView: AsyncImageView?
    @IBOutlet weak var tableView: UITableView?
    var viewModel = PersonDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.load()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.appear()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? ShowDetailViewController
        let show = viewModel.data[viewModel.selectedIndexForNavigation].show
        let isFavorited = viewModel.data[viewModel.selectedIndexForNavigation].isFavorited
        destination?.viewModel.show = show
        destination?.viewModel.isFavorited = isFavorited
    }

    // When the table view stops scrolling,
    // this will load the images. This helps
    // to avoid the flickering of
    // async + cell reuse
    private func loadImages() {
        tableView?.indexPathsForVisibleRows?.forEach {
            let show = viewModel.data[$0.row].show
            let cell = tableView?.cellForRow(at: $0) as? MediaTableViewCell
            cell?.mediaImageView?.loadImage(show.poster)
        }
    }

    private func setupBindings() {
        viewModel.onLoadingChange = { [weak self] isLoading in
            self?.nameLabel?.isHidden = isLoading
            self?.mediaImageView?.isHidden = isLoading
            let dataCount = self?.viewModel.data.count ?? 0
            self?.tableView?.isHidden = isLoading || dataCount == 0
            // When the loading finishes and there's no data
            // show a proper message
            if !isLoading, dataCount == 0 {
                self?.view.showMessageLabel("No shows to display.")
            } else {
                self?.view.hideMessageLabel()
            }
            isLoading ? self?.view.showLoading() : self?.view.hideLoading()
        }
        viewModel.onDataChange = { [weak self] in
            self?.nameLabel?.text = self?.viewModel.person?.name
            self?.mediaImageView?.loadImage(self?.viewModel.person?.image)
            self?.tableView?.reloadData()
        }
    }
}

extension PersonDetailViewController: UITableViewDelegate {
    // These scroll view methods are called indicating
    // the user is not scrolling the table view
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        loadImages()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImages()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Participated on these shows"
    }

    // Navigate to the shows the person participated
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedIndexForNavigation = indexPath.row
        performSegue(withIdentifier: "personDetailToShowDetailSegue", sender: nil)
    }
}

extension PersonDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personDetailsCell", for: indexPath) as? MediaTableViewCell
        let show = viewModel.data[indexPath.row].show
        let isFavorited = viewModel.data[indexPath.row].isFavorited
        cell?.viewModel.isFavorited = isFavorited
        cell?.viewModel.isFavoriteEnabled = true
        // If the table view is scrolling, set a placeholder
        // Otherwise, loads the image asynchronously
        if tableView.isDragging || tableView.isDecelerating {
            cell?.mediaImageView?.setPlaceholder()
        } else {
            cell?.mediaImageView?.loadImage(show.poster)
        }
        cell?.descriptionLabel?.text = show.name
        // When there's a tap on a favorite
        // ask the view model to handle
        cell?.viewModel.onFavoriteTap = { [weak self] in
            self?.viewModel.favorite(index: indexPath.row)
        }
        return cell ?? UITableViewCell()
    }
}
