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

    private let userDisplayNameFormatter = UserDisplayNameFormatter()
    private let usersDataProvider: UsersDataProvider
    private var currentSearchProgress: Progress?
    private var results: [User] = []

    // MARK: - Public Properties

    weak var delegate: UserSearchViewModelDelegate? = nil

    var searchText: String? = nil {
        didSet {
            searchTextDidUpdate(searchText)
        }
    }

    var numberOfResults: Int {
        return results.count
    }

    // MARK: - Public API

    func cellViewModelAtIndex(_ index: Int) -> UserSearchCellViewModel {
        return UserSearchCellViewModel(user: results[index])
    }

    func userViewModelAtIndex(_ index: Int) -> UserViewModel {
        return UserViewModel(user: results[index])
    }

    // MARK: - Private API

    private func searchTextDidUpdate(_ searchText: String?) {
        currentSearchProgress?.cancel()
        guard let searchText = searchText, !searchText.isEmpty else {
            updateResults(withUsers: [])
            return
        }

        self.currentSearchProgress = usersDataProvider.search(query: searchText) { result in
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
        self.results = users.sorted() { (lhs, rhs) -> Bool in
            let lhsName = userDisplayNameFormatter.displayName(for: lhs)
            let rhsName = userDisplayNameFormatter.displayName(for: rhs)
            return lhsName < rhsName
        }

        DispatchQueue.main.async {
            self.delegate?.userSearchViewModelHasUpdatedResults(self)
        }
    }

    private func handleError(_ error: Error) {
        guard !error.isUrlCancelled else {
            return
        }

        self.updateResults(withUsers: [])
        DispatchQueue.main.async {
            self.delegate?.userSearchViewModel(self, didEncounterError: error)
        }
    }

}
