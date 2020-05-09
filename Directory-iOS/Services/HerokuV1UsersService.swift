//
// HerokuV1UsersService.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

class HerokuV1UsersService: UsersService {

    // MARK: - Configuration

    struct Configuration {
        static let `default` = Configuration(baseUrl: URL(string: "https://afternoon-journey-04115.herokuapp.com")!)
        static let local = Configuration(baseUrl: URL(string: "http://localhost:8080")!)

        let baseUrl: URL
        let urlSession: URLSession

        init(baseUrl: URL, urlSession: URLSession = .shared) {
            self.baseUrl = baseUrl
            self.urlSession = urlSession
        }

    }

    // MARK: - Errors

    enum Errors: Error {
        case unimplemented
    }

    // MARK: - Private Properties

    private let configuration: Configuration

    // MARK: - Initializers

    init(_ configuration: Configuration = .default) {
        self.configuration = configuration
    }

    // MARK: - Users Service

    func search(query: String, completion: @escaping (Result<[User], Error>) -> ()) -> Progress {
        DispatchQueue.main.async {
            completion(.failure(Errors.unimplemented))
        }
        return Progress()
    }

}
