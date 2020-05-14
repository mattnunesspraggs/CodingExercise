//
// DefaultUsersDataProvider.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

class DefaultUsersDataProvider: UsersDataProvider {

    // MARK: - Initializers

    init(_ usersService: UsersService) {
        self.usersService = usersService
    }

    // MARK: - Private Properties

    let usersService: UsersService

    // MARK: - UsersDataProvider

    func search(query: String, completion: @escaping (Result<[User], Error>) -> ()) -> Progress {
        return usersService.search(query: query, completion: completion)
    }

}
