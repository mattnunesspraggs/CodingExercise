//
// UserSearchResponseTests.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import XCTest

class UserSearchResponseTests: XCTestCase {

    func testEmptyUserResponseCodableConformance() throws {

        /**
         This test method depends on the fact that the en/decoders
         throw an error if something goes wrong, and are silent
         otherwise. It does _not_ verify that the object was decoded correctly.
         */

        let decoder = JSONDecoder()
        let testResponse = try decoder.decode(UserSearchResponse.self,
                                              from: TestFixtures.emptyUserSearchResponseJSON.data)

        XCTAssertFalse(testResponse.ok)
        XCTAssert(testResponse.users.isEmpty)

        let encoder = JSONEncoder()
        _ = try encoder.encode(testResponse)

    }

    func testSingleUserResponseCodableConformance() throws {

        /**
         This test method depends on the fact that the en/decoders
         throw an error if something goes wrong, and are silent
         otherwise. It does _not_ verify that the object was decoded correctly.
         */

        let decoder = JSONDecoder()
        let testResponse = try decoder.decode(UserSearchResponse.self,
                                              from: TestFixtures.singleUserSearchResponseJSON.data)

        XCTAssert(testResponse.ok)
        XCTAssert(testResponse.users.count == 1)

        let encoder = JSONEncoder()
        _ = try encoder.encode(testResponse)

    }

    func testMultipleUserResponseCodableConformance() throws {

        /**
         This test method depends on the fact that the en/decoders
         throw an error if something goes wrong, and are silent
         otherwise. It does _not_ verify that the object was decoded correctly.
         */

        let decoder = JSONDecoder()
        let testResponse = try decoder.decode(UserSearchResponse.self,
                                              from: TestFixtures.multipleUserSearchResponseJSON.data)

        XCTAssert(testResponse.ok)
        XCTAssert(testResponse.users.count > 1)

        let encoder = JSONEncoder()
        _ = try encoder.encode(testResponse)

    }

}
