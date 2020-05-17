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

    func search(query: String, completion: @escaping (Result<[User], Error>) -> ()) -> Progress {
        let request = urlRequestForQuery(query)
        return submitRequest(request) { (result: Result<UserSearchResponse, Error>) in
            completion(result.map { $0.users })
        }
    }

    func imageData(size: User.ImageSize, for user: User, completion: @escaping (Result<Data, Error>) -> ()) -> Progress {
        let request = urlRequestForImage(size: size, for: user)
        return submitDataRequest(request) { result in
            // throw away the `URLResponse?`
            completion(result.map { $0.0 })
        }
    }

    // MARK: - Private API

    private func urlRequestForImage(size: User.ImageSize, for user: User) -> URLRequest {
        let components = URLComponents(string: "/1.0/users/" + user.id + "/pictures/" + size.rawValue)!
        let url = components.url(relativeTo: configuration.baseUrl)!
        return URLRequest(url: url)
    }

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

    private func submitDataRequest(_ request: URLRequest,
                                   completion: @escaping (Result<(Data, URLResponse?), Error>) -> ()) -> Progress {
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

            // 4. Return the data and the response
            completion(.success((data, maybeResponse)))
        }

        task.resume()
        return task.progress
    }

    private func submitRequest<ResultType: Codable>(_ request: URLRequest,
                                                    completion: @escaping (Result<ResultType, Error>) -> ()) -> Progress {
        return submitDataRequest(request) { result in
            let transformedResult = result.flatMap { (data, args) -> Result<ResultType, Error> in
                do {
                    let result = try self.jsonDecoder.decode(ResultType.self, from: data)
                    return .success(result)
                } catch {
                    return .failure(error)
                }
            }
            completion(transformedResult)
        }
    }

}
