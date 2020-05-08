//
// User+Pictures.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

extension User {

    struct Pictures: Codable {
        let large: URL
        let medium: URL
        let thumbnail: URL
    }

}
