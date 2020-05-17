//
// Cache.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import UIKit

class Cache<Payload> {

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

    func cache(_ object: Payload, forKey key: String, until expires: Date? = nil) {
        let entry = Entry(expires: expires, payload: object)
        cache.setObject(entry, forKey: key as NSString)
    }

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

    func removeObject(for key: String) {
        cache.removeObject(forKey: key as NSString)
    }

    func removeAllObjects() {
        cache.removeAllObjects()
    }

}
