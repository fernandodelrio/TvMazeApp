//
//  ShowListViewController.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import UIKit

class ShowListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView?
    lazy var viewModel = ShowListViewModel()
    @IBOutlet weak var bottomLoadingView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            if !isLoading, dataCount == 0 {
                self?.view.showMessageLabel("No results found.")
            } else {
                self?.view.hideMessageLabel()
            }
        }
        viewModel.onLoadingNewPageChange = { [weak self] isLoading in
            self?.bottomLoadingView?.isHidden = !isLoading
        }
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
    
    func loadImages() {
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
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        loadImages()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImages()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == viewModel.data.count {
            viewModel.loadNewPages()
        }
    }
    
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
        cell?.isFavorited = isFavorited
        cell?.isFavoriteEnabled = true
        if tableView.isDragging || tableView.isDecelerating {
            cell?.mediaImageView?.setPlaceholder()
        } else {
            cell?.mediaImageView?.loadImage(show.poster)
        }
        cell?.descriptionLabel?.text = show.name
        cell?.onFavoriteTap = { [weak self] in
            self?.viewModel.favorite(index: indexPath.row)
        }
        return cell ?? UITableViewCell()
    }
}
