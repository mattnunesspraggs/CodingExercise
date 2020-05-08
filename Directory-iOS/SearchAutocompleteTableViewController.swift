//
// SearchAutocompleteTableViewController.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import UIKit

class SearchAutocompleteTableViewController: UITableViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Private Variables

    private var savedPrefersLargeTitle: Bool? = nil

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let navigationBar = navigationController?.navigationBar {
            self.savedPrefersLargeTitle = navigationBar.prefersLargeTitles
            navigationBar.prefersLargeTitles = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let navigationBar = navigationController?.navigationBar,
            let savedValue = savedPrefersLargeTitle {
            navigationBar.prefersLargeTitles = savedValue
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}

// MARK: - UISearchBarDelegate

extension SearchAutocompleteTableViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: false)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(false)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }

}
