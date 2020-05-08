//
// User+Nationality.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

extension User {

    enum Nationality: String, Codable {
        case australia = "au"
        case brazil = "br"
        case canada = "ca"
        case switzerland = "ch"
        case germany = "de"
        case denmark = "dk"
        case spain = "es"
        case finland = "fi"
        case france = "fr"
        case unitedKingdom = "gb"
        case ireland = "ie"
        case norway = "no"
        case netherlands = "nl"
        case newZealand = "nz"
        case turkey = "tr"
        case unitedStates = "us"

        var isoCountryCode: String {
            return rawValue
        }
    }

}
