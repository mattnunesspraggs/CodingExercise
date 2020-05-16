//
// UserSearchCellViewModel.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

class UserSearchCellViewModel {

    // MARK: - Public Properties

    private let user: User
    private let userDisplayNameFormatter = UserDisplayNameFormatter()

    // MARK: - Initialization

    init(user: User) {
        self.user = user
    }

    // MARK: - Public API

    var displayName: String {
        return userDisplayNameFormatter.displayName(for: user)
    }

    var username: String {
        return user.username
    }

}
