//
// User+Nationality.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

extension User {

    enum Nationality: String, Codable {
        case australia = "AU"
        case brazil = "BR"
        case canada = "CA"
        case switzerland = "CH"
        case germany = "DE"
        case denmark = "DK"
        case spain = "ES"
        case finland = "FI"
        case france = "FR"
        case unitedKingdom = "GB"
        case ireland = "IE"
        case norway = "NO"
        case netherlands = "NL"
        case newZealand = "NZ"
        case turkey = "TR"
        case unitedStates = "US"

        var isoCountryCode: String {
            return rawValue
        }
    }

}
