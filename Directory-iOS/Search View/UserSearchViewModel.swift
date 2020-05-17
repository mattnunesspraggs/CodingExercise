//
// UserSearchViewModel.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

// MARK: - Delegate Protocol

protocol UserSearchViewModelDelegate: class {
    func userSearchViewModelHasUpdatedResults(_ viewModel: UserSearchViewModel)
    func userSearchViewModel(_ viewModel: UserSearchViewModel, didEncounterError error: Error)
}

// MARK: - View Model

// TODO:
//  - sort by CNContactSortOrder, username
//  - expose sort controls
//  - support UITableView sections + section indexes

class UserSearchViewModel {

    // MARK: - Initializers

    init(_ dataProvider: UsersDataProvider) {
        self.usersDataProvider = dataProvider
    }

    // MARK: - Private Properties

    private let userDisplayNameFormatter: UserDisplayNameFormatter = .shared
    private let usersDataProvider: UsersDataProvider
    private var currentSearchProgress: Progress?
    private var results: [User] = []

    // MARK: - Public Properties

    /// The view model's delegate.
    weak var delegate: UserSearchViewModelDelegate? = nil

    /// The current search text, or `nil`.
    var searchText: String? = nil {
        didSet {
            if oldValue != searchText {
                searchTextDidUpdate(searchText)
            }
        }
    }

    /// The number of search results, after a search operation.
    var numberOfResults: Int {
        return results.count
    }

    /// Returns whether a search is currently in progress.
    var isLoading: Bool {
        return currentSearchProgress != nil
    }

    // MARK: - Public API

    /**
     Returns a `UserSearchCellViewModel` for the search result at a
     given index.

     - Parameter index: An index into the search results.
     - Returns: A `UserSearchCellViewModel`.
     */

    func cellViewModelAtIndex(_ index: Int) -> UserSearchCellViewModel {
        return UserSearchCellViewModel(user: results[index], dataProvider: usersDataProvider)
    }

    /**
     Returns a `UserViewModel` for the search result at a
     given index.

     - Parameter index: An index into the search results.
     - Returns: A `UserViewModel`.
     */

    func userViewModelAtIndex(_ index: Int) -> UserViewModel {
        return UserViewModel(user: results[index], dataProvider: usersDataProvider)
    }

    // MARK: - Private API

    private func searchTextDidUpdate(_ searchText: String?) {
        currentSearchProgress?.cancel()

        guard let searchText = searchText, !searchText.isEmpty else {
            updateResults(withUsers: [])
            return
        }

        self.currentSearchProgress = usersDataProvider.search(query: searchText) { result in
            guard searchText == self.searchText else {
                return
            }

            switch result {
            case .success(let users):
                self.updateResults(withUsers: users)

            case .failure(let error):
                self.handleError(error)
            }
            self.currentSearchProgress = nil
        }
    }

    private func updateResults(withUsers users: [User]) {
        guard users != results else {
            return
        }

        DispatchQueue.main.async {
            self.results = users.sorted() { (lhs, rhs) -> Bool in
                let lhsName = self.userDisplayNameFormatter.displayName(for: lhs)
                let rhsName = self.userDisplayNameFormatter.displayName(for: rhs)
                return lhsName < rhsName
            }
            self.delegate?.userSearchViewModelHasUpdatedResults(self)
        }
    }

    private func handleError(_ error: Error) {
        guard !error.isUrlCancelledError else {
            return
        }

        self.updateResults(withUsers: [])
        DispatchQueue.main.async {
            self.delegate?.userSearchViewModel(self, didEncounterError: error)
        }
    }

}
