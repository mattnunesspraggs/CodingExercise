//
// UserFixtures.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

enum TestFixtures: String {

    case singleUserJSON = "singleUser.json"
    case emptyUserSearchResponseJSON = "emptyUserSearchResponse.json"
    case singleUserSearchResponseJSON = "singleUserSearchResponse.json"
    case multipleUserSearchResponseJSON = "multipleUserSearchResponse.json"

    var url: URL {
        return Bundle(for: _TestFixtures.self).url(forResource: rawValue, withExtension: nil)!
    }

    var data: Data {
        return try! Data(contentsOf: url)
    }

}

/* Dummy class to use in `Bundle(for:)` above - can't use `TestFixtures.self`, it's not a class. */
class _TestFixtures {}
