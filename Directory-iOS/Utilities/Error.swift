//
// Error.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

extension Error {

    var isUrlCancelled: Bool {
        let cocoaError = self as NSError
        return (cocoaError.domain == NSURLErrorDomain && cocoaError.code == NSURLErrorCancelled)
    }

}
