//
// UsersDataProvider.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

#if os(iOS)
import UIKit
#endif

/**
 A protocol representing an wrapper around the `UsersService` protocol. It's the natural
 place to add caching, debounce, throttling, etc.
 */

protocol UsersDataProvider {

    func search(query: String, completion: @escaping (Result<[User], Error>) -> ()) -> Progress

    #if os(iOS)
    func image(size: User.ImageSize, for user: User, completion: @escaping (Result<UIImage, Error>) -> ()) -> Progress
    #endif

}

