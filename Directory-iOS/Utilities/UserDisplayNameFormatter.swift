//
// UserDisplayNameFormatter.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

/**
 A formatter for generating a `User`'s display name from
 the object's name components.
 */

struct UserDisplayNameFormatter {

    // MARK: - Static Properties

    static let shared = UserDisplayNameFormatter()

    // MARK: - Private Properties

    private let personNameComponentsFormatter: PersonNameComponentsFormatter

    // MARK: - Initializers

    init(personNameComponentsFormatter: PersonNameComponentsFormatter = .init()) {
        self.personNameComponentsFormatter = personNameComponentsFormatter
    }

    // MARK: - Public API

    func displayName(for user: User) -> String {
        return personNameComponentsFormatter.string(from: user.personNameComponents)
    }

}
