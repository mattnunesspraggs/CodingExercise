//
// UserDisplayNameFormatter.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

struct UserDisplayNameFormatter {

    let personNameComponentsFormatter: PersonNameComponentsFormatter

    init(personNameComponentsFormatter: PersonNameComponentsFormatter = .init()) {
        self.personNameComponentsFormatter = personNameComponentsFormatter
    }

    func displayName(for user: User) -> String {
        return personNameComponentsFormatter.string(from: user.personNameComponents)
    }

}
