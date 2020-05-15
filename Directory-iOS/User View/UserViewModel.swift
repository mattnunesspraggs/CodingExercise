//
// UserViewModel.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation
import Contacts

class UserViewModel {

    // MARK: - Types

    enum PhoneNumber {
        case home(String)
        case cell(String)
        case other(String, String)
    }

    // MARK: - Static Properties

    static let defaultNameFormatter: PersonNameComponentsFormatter = {
        var formatter = PersonNameComponentsFormatter()
        formatter.style = .default
        return formatter
    }()

    static let defaultPostalAddressFormatter: CNPostalAddressFormatter = {
        var formatter = CNPostalAddressFormatter()
        formatter.style = .mailingAddress
        return formatter
    }()

    // MARK: - Private Properties

    private let user: User

    // MARK: - Initializers

    init(user: User) {
        self.user = user
    }

    // MARK: - Public API

    var username: String {
        return user.username
    }

    var email: String {
        return user.email
    }

    var displayName: String {
        return displayName()
    }

    var phoneNumbers: [PhoneNumber] {
        return [
            .home(user.phoneNumbers.home),
            .cell(user.phoneNumbers.cell)
        ]
    }

    var formattedAddress: String {
        return formattedAddress()
    }

    var isoCountryCode: String {
        return user.nationality.rawValue
    }

    var countryFlag: String {
        return user.nationality.flagString
    }

    func displayName(formatter: PersonNameComponentsFormatter = UserViewModel.defaultNameFormatter) -> String {
        return formatter.string(from: user.nameComponents)
    }

    func formattedAddress(formatter: CNPostalAddressFormatter = UserViewModel.defaultPostalAddressFormatter) -> String {
        return formatter.string(from: user.postalAddress)
    }

}

// MARK: - User Extensions

extension User {

    fileprivate var nameComponents: PersonNameComponents {
        var components = PersonNameComponents()
        components.givenName = name.first
        components.familyName = name.last
        return components
    }

    fileprivate var postalAddress: CNPostalAddress {
        let address = CNMutablePostalAddress()
        address.street = location.street
        address.city = location.city
        address.state = location.state
        address.postalCode = location.postcode
        address.country = location.country
        address.isoCountryCode = nationality.isoCountryCode
        return address
    }

}

extension User.Nationality {

    var flagString: String {
        switch self {
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
