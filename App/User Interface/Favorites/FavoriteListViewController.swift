//
//  FavoriteListViewController.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import UIKit

class FavoriteListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var viewModel = FavoriteListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onDataChange = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.appear()
    }

    func loadImages() {
        tableView.indexPathsForVisibleRows?.forEach {
            let show = viewModel.data[$0.row].show
            let cell = tableView.cellForRow(at: $0) as? MediaTableViewCell
            cell?.mediaImageView?.loadImage(show.poster)
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
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
        return cell ?? UITableViewCell()
    }
}

