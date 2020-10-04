//
//  FavoriteListViewController.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import Core
import UIKit

class FavoriteListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView?
    var viewModel = FavoriteListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = MainTab.favorites.title
        setupBindings()
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

    // Reloads the table view when there's data
    // or just hides it
    private func reloadTableView() {
        let dataCount = viewModel.data.count
        if dataCount > 0 {
            tableView?.isHidden = false
            tableView?.reloadData()
        } else {
            tableView?.isHidden = true
        }
    }

    // When there's no data, show a message instead
    private func updateMessageLabel(isLoading: Bool) {
        let dataCount = viewModel.data.count
        if !isLoading, dataCount == 0 {
            view.showMessageLabel("No favorites to show.".localized)
        } else {
            view.hideMessageLabel()
        }
    }

    private func setupBindings() {
        viewModel.onDataChange = { [weak self] in
            self?.reloadTableView()
        }
        // When a data is deleted, delete on UI as well
        viewModel.onDataDelete = { [weak self] indexPath in
            self?.tableView?.deleteRows(at: [indexPath], with: .left)
            self?.reloadTableView()
            self?.updateMessageLabel(isLoading: false)
        }
        viewModel.onLoadingChange = { [weak self] isLoading in
            isLoading ? self?.view.showLoading() : self?.view.hideLoading()
            self?.updateMessageLabel(isLoading: isLoading)
        }
    }
}

extension FavoriteListViewController: UITableViewDelegate {
    // These scroll view methods are called indicating
    // the user is not scrolling the table view
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        loadImages()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImages()
    }

    // Navigate to favorite details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedIndexForNavigation = indexPath.row
        performSegue(withIdentifier: "favoriteListToDetailSegue", sender: nil)
    }
}

extension FavoriteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as? MediaTableViewCell
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
        // When there's a tap on a favorite, we
        // just want to remove from this list
        cell?.viewModel.onFavoriteTap = { [weak self] in
            self?.viewModel.unfavorite(index: indexPath.row)
        }
        return cell ?? UITableViewCell()
    }
}

