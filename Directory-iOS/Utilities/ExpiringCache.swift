//
// ExpiringCache.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import UIKit

/**
 A class implementing an expiring object cache.

 This class uses `NSCache` internally, which means that
 objects may be evicted in response to memory pressure
 before their expiration. This is considered a feature
 rather than a bug.

 - Note: The class does not forcibly evict objects when
    they expire; rather, they will be evicted when next
    accessed.
 */

class ExpiringCache<Payload> {

    // MARK: - Types

    private class Entry {
        let expires: Date?
        let payload: Payload

        init(expires: Date? = nil, payload: Payload) {
            self.expires = expires
            self.payload = payload
        }
    }

    // MARK: - Private API

    private let cache = NSCache<NSString, Entry>()

    // MARK: - Public API

    /**
     Adds an object to the cache.

     - Parameter object: The object to be cached.
     - Parameter key: The key under which to cache the object.
     - Parameter expires: An optional expiration date, after which the object is considered expired.
     */

    func setObject(_ object: Payload, forKey key: String, until expires: Date? = nil) {
        let entry = Entry(expires: expires, payload: object)
        cache.setObject(entry, forKey: key as NSString)
    }

    /**
     Returns an object from the cache.

     - Parameter key: The key under which to find the object.
     - Returns: The object, or `nil` if the object does not exist
        or has expired.
     */

    func cachedObject(forKey key: String) -> Payload? {
        guard let entry = cache.object(forKey: key as NSString) else {
            return nil
        }

        if let expires = entry.expires, expires < Date() {
            cache.removeObject(forKey: key as NSString)
            return nil
        }

        return entry.payload
    }

    /**
     Removes an object from the cache.

     - Parameter key: The key identifying the object to be removed.
     */

    func removeObject(for key: String) {
        cache.removeObject(forKey: key as NSString)
    }

    /**
     Removes all objects from the cache.
     */
    func removeAllObjects() {
        cache.removeAllObjects()
    }

}
