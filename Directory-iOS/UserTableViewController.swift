//
// UserTableViewController.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import UIKit

class UserTableViewController: UITableViewController, UIStoryboardInstatiable {

    // MARK: - UIStoryboardInstantiable

    static var storyboardIdentifier: String { "UserTableViewController" }

    // MARK: - Public Properties

    var userViewModel: UserViewModel? = nil {
        didSet {
            navigationItem.title = userViewModel?.displayName ?? ""
        }
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

}
