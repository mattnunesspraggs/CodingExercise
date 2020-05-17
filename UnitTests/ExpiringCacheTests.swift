//
// ExpiringCacheTests.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import XCTest

class ExpiringCacheTests: XCTestCase {

    func testCacheWithoutExpiration() {

        let cache = ExpiringCache<String>()
        let cacheObjects = ["foo": "bar", "quux": "corge"]

        // 1. Add the test objects to the cache.

        cacheObjects.forEach { (key, object) in
            cache.setObject(object, forKey: key)
        }

        // 2. Check that those objects are actually in the cache.

        cacheObjects.forEach { (key, expected) in
            XCTAssertEqual(expected,
                           cache.cachedObject(forKey: key))
        }

        // 3. Remove each object from the cache.

        cacheObjects.forEach { (key, _) in
            cache.removeObject(for: key)
        }

        // 4. Ensure that each object is no longer in the cache.

        cacheObjects.forEach { (key, _) in
            XCTAssertNil(cache.cachedObject(forKey: key))
        }

    }

    func testCacheWithExpiration() {

        let cache = ExpiringCache<String>()
        let cacheObjects = ["foo": "bar", "quux": "corge"]

        // 1. Add the test objects to the cache with a past expiration.

        cacheObjects.forEach { (key, object) in
            cache.setObject(object, forKey: key, until: Date.distantPast)
        }

        // 2. Ensure that each object is not returned from the cache.

        cacheObjects.forEach { (key, _) in
            XCTAssertNil(cache.cachedObject(forKey: key))
        }

        // 3. Add the test objects to the cache with a distant expiration.

        cacheObjects.forEach { (key, object) in
            cache.setObject(object, forKey: key, until: Date.distantFuture)
        }

        // 4. Check that those objects are still in the cache.

        cacheObjects.forEach { (key, expected) in
            XCTAssertEqual(expected,
                           cache.cachedObject(forKey: key))
        }

    }

    func testRemoveAllObjects() {

        let cache = ExpiringCache<String>()
        let cacheObjects = ["foo": "bar", "quux": "corge"]

        // 1. Add the test objects to the cache.

        cacheObjects.forEach { (key, object) in
            cache.setObject(object, forKey: key)
        }

        // 2. Remove all objects from the cache.

        cache.removeAllObjects()

        // 3. Ensure that each object is no longer in the cache.

        cacheObjects.forEach { (key, _) in
            XCTAssertNil(cache.cachedObject(forKey: key))
        }

    }

}
