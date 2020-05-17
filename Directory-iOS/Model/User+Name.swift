//
// User+Name.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

extension User {

    struct Name: Codable, Equatable {
        let title: String
        let first: String
        let last: String
    }

}
