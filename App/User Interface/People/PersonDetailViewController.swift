//
//  PersonDetailViewController.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/2/20.
//

import UIKit

class PersonDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mediaImageView: AsyncImageView!
    @IBOutlet weak var tableView: UITableView!
}

extension PersonDetailViewController: UITableViewDelegate {
    
}

extension PersonDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
