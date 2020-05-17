//
// DefaultUsersDataProvider.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation
#if os(iOS)
import UIKit
#endif

class DefaultUsersDataProvider: UsersDataProvider {

    // MARK: - Types

    enum Errors: Error {
        case badImageData
    }

    private struct Constants {
        static let userImageMaxStale: TimeInterval = 3600 // 1 hr, in seconds
        static func userImageCacheExpiration() -> Date {
            return Date(timeIntervalSinceNow: userImageMaxStale)
        }
    }

    // MARK: - Initializers

    init(_ usersService: UsersService) {
        self.usersService = usersService
    }

    // MARK: - Private Properties

    let usersService: UsersService

    #if os(iOS)
    var imageCache = Cache<UIImage>()
    #endif

    // MARK: - UsersDataProvider

    func search(query: String, completion: @escaping (Result<[User], Error>) -> ()) -> Progress {
        return usersService.search(query: query, completion: completion)
    }

    #if os(iOS)
    func image(size: User.ImageSize, for user: User, completion: @escaping (Result<UIImage, Error>) -> ()) -> Progress {
        if let cachedImage = cachedImage(size: size, for: user) {
            completion(.success(cachedImage))
            return Progress()
        }

        return usersService.imageData(size: size, for: user) { result in
            let imageResult = result.flatMap { data -> Result<UIImage, Error> in
                guard let image = UIImage(data: data) else {
                    return .failure(Errors.badImageData)
                }
                self.cacheImage(image: image, size: size, user: user)
                return .success(image)
            }
            completion(imageResult)
        }
    }
    #endif

    // MARK: - Private API

    #if os(iOS)
    private func cachedImage(size: User.ImageSize, for user: User) -> UIImage? {
        return imageCache.cachedObject(forKey: "\(user.id)::\(size.rawValue)")
    }

    private func cacheImage(image: UIImage, size: User.ImageSize, user: User) {
        imageCache.cache(image, forKey: "\(user.id)::\(size.rawValue)",
            until: Constants.userImageCacheExpiration())
    }
    #endif

}
