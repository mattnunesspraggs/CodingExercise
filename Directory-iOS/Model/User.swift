//
// User.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

struct User: Codable, Equatable {

    // MARK: - Custom Coding Keys

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case username
        case location
        case email
        case phoneNumbers = "phone_numbers"
        case nationality
    }

    // MARK: - Properties

    let id: String
    let name: Name
    let username: String
    let location: Location
    let email: String
    let phoneNumbers: PhoneNumbers
    let nationality: Nationality

}
