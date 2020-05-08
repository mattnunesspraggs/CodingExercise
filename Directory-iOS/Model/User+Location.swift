//
// User+Location.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

extension User {

    struct Location: Codable {

        // MARK: - Custom Coding Keys

        enum CodingKeys: String, CodingKey {
            case street
            case city
            case state
            case country
            case postcode
            case timezoneOffset = "tz_offset"
        }

        // MARK: - Properties

        let street: String
        let city: String
        let state: String
        let country: String
        let postcode: String
        let timezoneOffset: String
    }

}
