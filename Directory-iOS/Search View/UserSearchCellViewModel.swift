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

    /// Returns the `User`'s display name.
    var displayName: String {
        return userDisplayNameFormatter.displayName(for: user)
    }


    /// Returns the `User`'s username.
    var username: String {
        return user.username
    }

    /**
     Loads the `User`'s thumbnail image.

     - Parameter completion: A block which is run when the operation is complete, taking a single parameter:
     - Parameter result: The `Result<UIImage, Error>` representing the result of the load operation.
     - Returns: A cancellable `Progress` object which represents the underlying loading operation.
     */
    func loadThumbnail(_ completion: @escaping (_ result: Result<UIImage, Error>) -> ()) -> Progress {
        return dataProvider.image(size: .thumbnail, for: user, completion: completion)
    }

}

extension UserSearchCellViewModel: Equatable {

    static func == (lhs: UserSearchCellViewModel, rhs: UserSearchCellViewModel) -> Bool {
        return lhs.user == rhs.user
    }

}
