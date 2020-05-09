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
        case badUrl(String, URL)
        case noDataReceived(URLRequest)
        case httpError(URLRequest, HTTPURLResponse)
    }

    // MARK: - Private Properties

    private let configuration: Configuration
    private let jsonDecoder = JSONDecoder()

    // MARK: - Initializers

    init(_ configuration: Configuration = .default) {
        self.configuration = configuration
    }

    // MARK: - Users Service

    func search(query: String, completion: @escaping (Result<UserSearchResponse, Error>) -> ()) -> Progress {
        return submitRequest(urlRequestForQuery(query), completion: completion)
    }

    // MARK: - Private API

    private func urlRequestForQuery(_ query: String) -> URLRequest {
        var components = URLComponents(string: "/1.0/users/search")!
        components.queryItems = [
            URLQueryItem(name: "query", value: query)
        ]

        let url = components.url(relativeTo: configuration.baseUrl)!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

    private func submitRequest<ResultType: Codable>(_ request: URLRequest,
                                                    completion: @escaping (Result<ResultType, Error>) -> ()) -> Progress {
        let task = configuration.urlSession.dataTask(with: request) { (maybeData, maybeResponse, maybeError) in
            // 1. If error != nil, then we've encounterd some kind of networking error.
            if let error = maybeError {
                return completion(.failure(error))
            }

            // 2. If this is an HTTP response (it may not be!), check the status code.
            if let httpResponse = maybeResponse as? HTTPURLResponse,
                !(200..<300).contains(httpResponse.statusCode) {
                let error = Errors.httpError(request, httpResponse)
                return completion(.failure(error))
            }

            // 3. If the data is empty, something weird is going on.
            guard let data = maybeData else {
                let error = Errors.noDataReceived(request)
                return completion(.failure(error))
            }

            // 4. Finally, attempt to decode the data into ResultType.
            do {
                let result = try self.jsonDecoder.decode(ResultType.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
        return task.progress
    }

}
