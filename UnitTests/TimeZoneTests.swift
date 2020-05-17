//
// TimeZoneTests.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import XCTest

class TimeZoneTests: XCTestCase {

    func testTimeZoneWithValidOffset() {

        // Test varied offset strings and ensure that
        // the resulting TimeZone's secondsFromGMT() returns
        // the correct value, as specified in the dictionary.

        let validOffsets = [
            "+1:25": 5100, "+02:36": 9360,
            "3:47": 13620, "04:58": 17880,
            "-1:25": -5100, "-02:36": -9360]

        validOffsets.forEach { (valid, actual) in
            let timezone = TimeZone(withOffset: valid)
            XCTAssertNotNil(timezone)
            XCTAssertEqual(actual, timezone?.secondsFromGMT())
        }

    }

    func testTimeZoneWithInvalidOffset() {

        // Tests a bunch of invalid offset strings. Expect nil.

        let invalidOffsets = ["-1.25", "-125", "x1:25", "foo"]

        invalidOffsets.forEach { valid in
            XCTAssertNil(TimeZone(withOffset: valid))
        }

    }

}
