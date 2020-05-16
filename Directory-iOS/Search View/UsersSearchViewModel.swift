//
// UsersSearchViewModel.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

// MARK: - Delegate Protocol

protocol UsersSearchViewModelDelegate: class {
    func usersSearchViewModelHasUpdatedResults(_ viewModel: UserSearchViewModel)
    func usersSearchViewModel(_ viewModel: UserSearchViewModel, didEncounterError error: Error)
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

    private let usersDataProvider: UsersDataProvider
    private var currentSearchProgress: Progress?
    private var results: [UserSearchCellViewModel] = []

    private var sort: (UserSearchCellViewModel, UserSearchCellViewModel) -> Bool = { lhs, rhs -> Bool in
        return lhs.displayName < rhs.displayName
    }

    private var filter: (UserSearchCellViewModel) -> Bool = { _ in return true }

    // MARK: - Public Properties

    weak var delegate: UsersSearchViewModelDelegate? = nil

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
        return results[index]
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
        let viewModels = users.map { UserSearchCellViewModel(user: $0) }
        let filteredViewModels = viewModels.filter(filter)
        let sortedViewModels = filteredViewModels.sorted(by: sort)
        self.results = sortedViewModels

        DispatchQueue.main.async {
            self.delegate?.usersSearchViewModelHasUpdatedResults(self)
        }
    }

    private func handleError(_ error: Error) {
        guard !error.isUrlCancelled else {
            return
        }

        self.updateResults(withUsers: [])
        DispatchQueue.main.async {
            self.delegate?.usersSearchViewModel(self, didEncounterError: error)
        }
    }

}
