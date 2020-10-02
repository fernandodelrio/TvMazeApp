//
//  PeopleListViewController.swift
//  TvMaze
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//  Copyright © 2020 Fernando Henrique Bonfim Moreno Del Rio. All rights reserved.
//

import UIKit

class PeopleListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var viewModel = PeopleListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onDataChange = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func loadImages() {
        tableView.indexPathsForVisibleRows?.forEach {
            let person = viewModel.data[$0.row]
            let cell = tableView.cellForRow(at: $0) as? MediaTableViewCell
            cell?.mediaImageView?.loadImage(person.image)
        }
    }
}

extension PeopleListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        viewModel.searchTextDidEndEditing(searchBar.text ?? "")
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchTextDidChange(searchText)
    }
}

extension PeopleListViewController: UITableViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        loadImages()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImages()
    }
}

extension PeopleListViewController: UITableViewDataSource {
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
