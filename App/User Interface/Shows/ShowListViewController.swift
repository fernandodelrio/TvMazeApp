//
//  ShowListViewController.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import Core
import UIKit

class ShowListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var bottomLoadingView: UIView?
    @IBOutlet weak var searchBar: UISearchBar?
    lazy var viewModel = ShowListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = MainTab.shows.title
        searchBar?.placeholder = "Search for shows".localized
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

    private func setupBindings() {
        viewModel.onDataChange = { [weak self] in
            let dataCount = self?.viewModel.data.count ?? 0
            if dataCount > 0 {
                self?.tableView?.isHidden = false
                self?.tableView?.reloadData()
            } else {
                self?.tableView?.isHidden = true
            }
        }
        viewModel.onLoadingChange = { [weak self] isLoading in
            isLoading ? self?.view.showLoading() : self?.view.hideLoading()
            let dataCount = self?.viewModel.data.count ?? 0
            // When the loading finishes and there's no data
            // show a proper message
            if !isLoading, dataCount == 0 {
                self?.view.showMessageLabel("No results found.".localized)
            } else {
                self?.view.hideMessageLabel()
            }
        }
        // Triggers the loading in the bottom of
        // the table view, while new data is loading
        viewModel.onLoadingNewPageChange = { [weak self] isLoading in
            self?.bottomLoadingView?.isHidden = !isLoading
        }
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
}

extension ShowListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        viewModel.searchTextDidEndEditing(searchBar.text ?? "")
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchTextDidChange(searchText)
    }
}

extension ShowListViewController: UITableViewDelegate {
    // These scroll view methods are called indicating
    // the user is not scrolling the table view
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        loadImages()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImages()
    }

    // When table view reach the bottom, load more data
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == viewModel.data.count {
            viewModel.loadNewPages()
        }
    }

    // Navigate to show details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedIndexForNavigation = indexPath.row
        performSegue(withIdentifier: "showListToDetailSegue", sender: nil)
    }
}

extension ShowListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showCell", for: indexPath) as? MediaTableViewCell
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
