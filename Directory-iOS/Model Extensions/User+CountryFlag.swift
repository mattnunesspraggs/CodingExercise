//
// User+CountryFlag.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation

extension User {

    /// A string containing the flag emoji for the `User`'s `nationality`.
    var countryFlag: String {
        switch nationality {
        case .australia: return "🇦🇺"
        case .brazil: return "🇧🇷"
        case .canada: return "🇨🇦"
        case .switzerland: return "🇨🇭"
        case .germany: return "🇩🇪"
        case .denmark: return "🇩🇰"
        case .spain: return "🇪🇸"
        case .finland: return "🇫🇮"
        case .france: return "🇫🇷"
        case .unitedKingdom: return "🇬🇧"
        case .ireland: return "🇮🇪"
        case .norway: return "🇳🇴"
        case .netherlands: return "🇳🇱"
        case .newZealand: return "🇳🇿"
        case .turkey: return "🇹🇷"
        case .unitedStates: return "🇺🇸"
        }
    }

}
