//
// SearchAutocompleteTableViewController.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import UIKit

class SearchAutocompleteTableViewController: UITableViewController {

    // MARK: - Private Variables

    private var searchController: UISearchController!
    private var savedPrefersLargeTitle: Bool? = nil
    private var usersSearchViewModel: UsersSearchViewModel!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        let service = HerokuV1UsersService()
        let provider = DefaultUsersDataProvider(service)
        self.usersSearchViewModel = UsersSearchViewModel(provider)
        self.usersSearchViewModel.delegate = self

        self.searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.becomeFirstResponder()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersSearchViewModel.numberOfResults
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let user = usersSearchViewModel.resultAtIndex(indexPath.row)
        cell.textLabel?.text = user.name.first + " " + user.name.last

        return cell
    }

    // MARK: - Private API

    private func presentError(_ error: Error) {
        let title = NSLocalizedString("Error", comment: "Error [Alert Title]")
        let alertController = UIAlertController(title: title,
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)

        let okTitle = NSLocalizedString("OK", comment: "OK [Error Alert Button Title]")
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: nil)
        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)
    }

}

// MARK: - UISearchResultsUpdating

extension SearchAutocompleteTableViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        usersSearchViewModel.searchText = searchController.searchBar.text
    }

}

// MARK: - UsersSearchViewModelDelegate

extension SearchAutocompleteTableViewController: UsersSearchViewModelDelegate {

    func usersSearchViewModelHasUpdatedResults(_ viewModel: UsersSearchViewModel) {
        tableView.reloadData()
    }

    func usersSearchViewModel(_ viewModel: UsersSearchViewModel, didEncounterError error: Error) {
        presentError(error)
    }

}
