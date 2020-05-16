//
// User+PersonNameComponents.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

extension User {

    /// The `User`'s name as an instance of `PersonNameComponents`.
    var personNameComponents: PersonNameComponents {
        var components = PersonNameComponents()
        components.givenName = name.first
        components.familyName = name.last
        return components
    }

}
