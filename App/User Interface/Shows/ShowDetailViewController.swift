//
//  ShowDetailViewController.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/2/20.
//

import UIKit

class ShowDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mediaImageView: AsyncImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    @IBAction func didTapFavoriteButton(_ sender: Any) {
    }
}

extension ShowDetailViewController: UITableViewDelegate {
    
}

extension ShowDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
