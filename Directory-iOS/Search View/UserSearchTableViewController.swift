//
// UserSearchTableViewController.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import UIKit

class UserSearchTableViewController: UITableViewController {

    // MARK: - Types

    private struct Constants {
        static let searchUserCellIdentifier = "SearchUserCell"
    }

    // MARK: - Private Variables

    private let searchViewModel: UserSearchViewModel = {
        let service = HerokuV1UsersService()
        let provider = DefaultUsersDataProvider(service)
        return UserSearchViewModel(provider)
    }()

    private let searchController: UISearchController! = {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()

    // MARK: - IBOutlets

    @IBOutlet var loadingTableHeaderView: UIView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!


    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        searchViewModel.delegate = self

        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true

        tableView.register(UserSearchTableViewCell.self,
                           forCellReuseIdentifier: Constants.searchUserCellIdentifier)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.becomeFirstResponder()
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.numberOfResults
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.searchUserCellIdentifier,
                                                 for: indexPath) as! UserSearchTableViewCell
        cell.viewModel = searchViewModel.cellViewModelAtIndex(indexPath.row)
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let splitViewController = splitViewController,
            let detailNavigationController = splitViewController.viewControllers.last as? UINavigationController else {
            return
        }

        let userTableViewController = UserTableViewController.instantiateFromStoryboard()
        userTableViewController.userViewModel = searchViewModel.userViewModelAtIndex(indexPath.row)
        detailNavigationController.pushViewController(userTableViewController, animated: true)

        splitViewController.showDetailViewController(detailNavigationController, sender: self)
    }

    // MARK: - UIScrollViewDelegate

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.endEditing(false)
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

extension UserSearchTableViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        searchViewModel.searchText = searchController.searchBar.text

        if searchViewModel.isLoading {
            tableView.tableHeaderView = loadingTableHeaderView
        }
    }

}

// MARK: - UsersSearchViewModelDelegate

extension UserSearchTableViewController: UserSearchViewModelDelegate {

    func userSearchViewModelHasUpdatedResults(_ viewModel: UserSearchViewModel) {
        if !searchViewModel.isLoading {
            tableView.tableHeaderView = nil
        }
        tableView.reloadData()
    }

    func userSearchViewModel(_ viewModel: UserSearchViewModel, didEncounterError error: Error) {
        presentError(error)
    }

}
