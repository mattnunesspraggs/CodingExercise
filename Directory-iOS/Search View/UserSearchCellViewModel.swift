//
// UserSearchCellViewModel.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import UIKit

class UserSearchCellViewModel {

    // MARK: - Public Properties

    private let user: User
    private let dataProvider: UsersDataProvider
    private let userDisplayNameFormatter: UserDisplayNameFormatter = .shared

    // MARK: - Initialization

    init(user: User, dataProvider: UsersDataProvider) {
        self.user = user
        self.dataProvider = dataProvider
    }

    // MARK: - Public API

    var displayName: String {
        return userDisplayNameFormatter.displayName(for: user)
    }

    var username: String {
        return user.username
    }

    func loadThumbnail(_ completion: @escaping (Result<UIImage, Error>) -> ()) -> Progress {
        return dataProvider.image(size: .thumbnail, for: user, completion: completion)
    }

}

extension UserSearchCellViewModel: Equatable {

    static func == (lhs: UserSearchCellViewModel, rhs: UserSearchCellViewModel) -> Bool {
        return lhs.user == rhs.user
    }

}
