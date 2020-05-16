//
// TimeZone.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

extension TimeZone {

    /**
     Instantiates a `TimeZone` from an offset string.

     The offset string should be formatted `/(+|-)([\d]{1,2}:[\d]{2}/`, i.e.
        - "-06:00"
        - "+05:45"

     - Parameter offset: The offset string to use in calculating the offset.
     - Note: This initializer delegates to `init(secondsFromGMT: _)`.
     */
    init?(withOffset offset: String) {
        let scanner = Scanner(string: offset)
        let negative = (scanner.scanString("-") != nil)
        guard let hours = scanner.scanInt(),
            let _ = scanner.scanString(":"),
            let minutes = scanner.scanInt() else {
            return nil
        }
        let secondsOffset = (negative ? -1 : 1) * ((hours * 3600) + (minutes * 60))
        self.init(secondsFromGMT: secondsOffset)
    }

}
