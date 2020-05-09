//
// UsersService.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

/**
 A protocol representing an object that talks to some backend service and provides user data.
 */

protocol UsersService {

    func search(query: String, completion: @escaping (Result<UserSearchResponse, Error>) -> ()) -> Progress

}
