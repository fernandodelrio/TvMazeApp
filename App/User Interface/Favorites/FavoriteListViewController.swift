//
//  FavoriteListViewController.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import UIKit

class FavoriteListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView?

    var viewModel = FavoriteListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onDataChange = { [weak self] in
            self?.reloadTableView()
        }
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

    func reloadTableView() {
        let dataCount = viewModel.data.count
        if dataCount > 0 {
            tableView?.isHidden = false
            tableView?.reloadData()
        } else {
            tableView?.isHidden = true
        }
    }

    func updateMessageLabel(isLoading: Bool) {
        let dataCount = viewModel.data.count
        if !isLoading, dataCount == 0 {
            view.showMessageLabel("No favorites to show.")
        } else {
            view.hideMessageLabel()
        }
    }
}

extension FavoriteListViewController: UITableViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        loadImages()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImages()
    }

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
        cell?.isFavorited = isFavorited
        cell?.isFavoriteEnabled = true
        if tableView.isDragging || tableView.isDecelerating {
            cell?.mediaImageView?.setPlaceholder()
        } else {
            cell?.mediaImageView?.loadImage(show.poster)
        }
        cell?.descriptionLabel?.text = show.name
        cell?.onFavoriteTap = { [weak self] in
            self?.viewModel.unfavorite(index: indexPath.row)
        }
        return cell ?? UITableViewCell()
    }
}

