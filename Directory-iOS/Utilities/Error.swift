//
// Error.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

extension Error {

    /**
     Returns `true` if the error's `domain` == `NSURLErrorDomain` and
     the error's `code` == `NSURLErrorCancelled`.
     */

    var isUrlCancelledError: Bool {
        let cocoaError = self as NSError
        return (cocoaError.domain == NSURLErrorDomain && cocoaError.code == NSURLErrorCancelled)
    }

}
