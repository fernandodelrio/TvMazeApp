//
//  PersonListViewController.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 9/30/20.
//

import UIKit

class PersonListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView?
    var viewModel = PersonListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.load()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? PersonDetailViewController
        let person = viewModel.data[viewModel.selectedIndexForNavigation]
        destination?.viewModel.person = person
    }

    // When the table view stops scrolling,
    // this will load the images. This helps
    // to avoid the flickering of
    // async + cell reuse
    private func loadImages() {
        tableView?.indexPathsForVisibleRows?.forEach {
            let person = viewModel.data[$0.row]
            let cell = tableView?.cellForRow(at: $0) as? MediaTableViewCell
            cell?.mediaImageView?.loadImage(person.image)
        }
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
                self?.view.showMessageLabel("No results found.")
            } else {
                self?.view.hideMessageLabel()
            }
        }
        // When the search is empty, show a message
        // asking the user to search something
        viewModel.onSearchEmpty = { [weak self] isEmpty in
            if isEmpty {
                self?.view.showMessageLabel("Search for interesting people.")
            } else {
                self?.view.hideMessageLabel()
            }
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

    // Navigate to the person's details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedIndexForNavigation = indexPath.row
        performSegue(withIdentifier: "peopleListToDetailSegue", sender: nil)
    }
}

extension PersonListViewController: UITableViewDelegate {
    // These scroll view methods are called indicating
    // the user is not scrolling the table view
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
        // On person list, make sure to disable
        // the favorite button
        cell?.viewModel.isFavoriteEnabled = false
        // If the table view is scrolling, set a placeholder
        // Otherwise, loads the image asynchronously
        if tableView.isDragging || tableView.isDecelerating {
            cell?.mediaImageView?.setPlaceholder()
        } else {
            cell?.mediaImageView?.loadImage(person.image)
        }
        cell?.descriptionLabel?.text = person.name
        return cell ?? UITableViewCell()
    }
}
