//
// UsersService.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

/**
 A protocol representing an object that talks to some backend service and provides user data.
 */

protocol UsersService {

    /**
     Searches for users.

     - Parameter query: The search text.
     - Parameter completion: A block which will be run when the search is completed. The completion takes a single parameter which is a `Result` type representing the result of the search.
     - Returns: A cancellable `Progress` object identifying the underlying request.
     */

    func search(query: String, completion: @escaping (Result<[User], Error>) -> ()) -> Progress

    /**
     Loads image data for an image of a given size for a `User`.

     - Parameter size: The size of image to load.
     - Parameter user: The `User` whose image should be loaded.
     - Parameter completion: A block which will be run when the image load is completed. The completion takes a single parameter:
     - Parameter result: A `Result<Data, Error>` representing the result of the loading operation.
     - Returns: A cancellable `Progress` object identifying the underlying request.
     */

    func imageData(size: User.ImageSize, for user: User, completion: @escaping (_ result: Result<Data, Error>) -> ()) -> Progress

}
