//
// UserTests.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import XCTest

class UserTests: XCTestCase {

    func testCodableConformance() throws {

        /**
         This test method depends on the fact that the en/decoders
         throw an error if something goes wrong, and are silent
         otherwise. It does _not_ verify that the object was decoded correctly.
         */

        let decoder = JSONDecoder()
        let testUser = try decoder.decode(User.self,
                                          from: TestFixtures.singleUserJSON.data)

        let encoder = JSONEncoder()
        _ = try encoder.encode(testUser)

    }

}
