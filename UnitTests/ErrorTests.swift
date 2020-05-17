//
// ErrorTests.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import XCTest

class ErrorTests: XCTestCase {

    func testErrorTypeIsUrlCancelled() {

        // Test that an arbitary `Error`-conforming type
        // returns false.

        enum Errors: Error {
            case testError
        }

        XCTAssertFalse(Errors.testError.isUrlCancelled)

    }

    func testNSErrorIsUrlCancelled() {

        // Test that an arbitrary `NSError` instance
        // returns false.

        let notCancelledError = NSError(domain: "", code: 0, userInfo: nil)
        XCTAssertFalse(notCancelledError.isUrlCancelled)

    }

    func testCancelledErrorIsUrlCancelled() {

        // Test that an `NSError` instance where
        // (domain == NSURLErrorDomain && code == NSURLErrorCancelled)
        // returns true.

        let cancelledError = NSError(domain: NSURLErrorDomain,
                                     code: NSURLErrorCancelled,
                                     userInfo: nil)
        XCTAssert(cancelledError.isUrlCancelled)

    }

}
