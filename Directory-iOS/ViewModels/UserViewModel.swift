//
// UserViewModel.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

class UserViewModel {

    // MARK: - Static Properties

    static let defaultNameFormatter: PersonNameComponentsFormatter = {
        var formatter = PersonNameComponentsFormatter()
        formatter.style = .default
        return formatter
    }()

    // MARK: - Private Properties

    private let user: User

    // MARK: - Initializers

    init(user: User) {
        self.user = user
    }

    // MARK: - Public API

    var username: String {
        return user.username
    }

    var displayName: String {
        return displayName()
    }

    func displayName(formatter: PersonNameComponentsFormatter = UserViewModel.defaultNameFormatter) -> String {
        return formatter.string(from: user.nameComponents)
    }

}

// MARK: - User Extensions

extension User {

    fileprivate var nameComponents: PersonNameComponents {
        var components = PersonNameComponents()
        components.givenName = name.first
        components.familyName = name.last
        return components
    }

}
