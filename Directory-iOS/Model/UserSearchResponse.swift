//
// UserSearchResponse.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

struct UserSearchResponse: Codable {

    let ok: Bool
    let users: [User]

}
