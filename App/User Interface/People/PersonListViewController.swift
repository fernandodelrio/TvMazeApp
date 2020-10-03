//
//  PersonListViewController.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//  Copyright © 2020 Fernando Henrique Bonfim Moreno Del Rio. All rights reserved.
//

import UIKit

class PersonListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView?
    var viewModel = PersonListViewModel()

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
        viewModel.onSearchEmpty = { [weak self] isEmpty in
            if isEmpty {
                self?.view.showMessageLabel("Search for interesting people.")
            } else {
                self?.view.hideMessageLabel()
            }
        }
        viewModel.load()
    }
    
    func loadImages() {
        tableView?.indexPathsForVisibleRows?.forEach {
            let person = viewModel.data[$0.row]
            let cell = tableView?.cellForRow(at: $0) as? MediaTableViewCell
            cell?.mediaImageView?.loadImage(person.image)
        }
    }
}

extension PersonListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        viewModel.searchTextDidEndEditing(searchBar.text ?? "")
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchTextDidChange(searchText)
    }
}

extension PersonListViewController: UITableViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        loadImages()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImages()
    }
}

extension PersonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as? MediaTableViewCell
        let person = viewModel.data[indexPath.row]
        cell?.isFavoriteEnabled = false
        if tableView.isDragging || tableView.isDecelerating {
            cell?.mediaImageView?.setPlaceholder()
        } else {
            cell?.mediaImageView?.loadImage(person.image)
        }
        cell?.descriptionLabel?.text = person.name
        return cell ?? UITableViewCell()
    }
}
