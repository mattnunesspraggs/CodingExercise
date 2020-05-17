//
// UserViewModel.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import UIKit
import Contacts

class UserViewModel {

    // MARK: - Static Properties

    static let defaultPostalAddressFormatter = CNPostalAddressFormatter()

    // MARK: - Private Properties

    private let user: User
    private let dataProvider: UsersDataProvider
    private let userDisplayNameFormatter = UserDisplayNameFormatter()

    // MARK: - Initializers

    init(user: User, dataProvider: UsersDataProvider) {
        self.user = user
        self.dataProvider = dataProvider
    }

    // MARK: - Public API

    /// Returns the `User`'s display name.
    var displayName: String {
        return userDisplayNameFormatter.displayName(for: user)
    }

    /// Returns the `User`'s data in logical sections and rows.
    var sectionViewModels: [SectionViewModel] {
        var sections: [SectionViewModel] = []

        // - - - - - CONTACT - - - - -
        sections.append(
            SectionViewModel(localizedTitle: .contactSectionTitle,
                             rowViewModels: [
                                RowViewModel(localizedLabel: .usernameFieldLabel,
                                             valueProvider: self.user.username),
                                RowViewModel(localizedLabel: .emailFieldLabel,
                                             valueProvider: self.user.email,
                                             accessoryType: .email)]))

        // - - - - - PHONE NUMBERS - - - - -
        sections.append(
            SectionViewModel(localizedTitle: .phoneSectionTitle,
                             rowViewModels: [
                                RowViewModel(localizedLabel: .homePhoneLabel,
                                             valueProvider: self.user.phoneNumbers.home,
                                             accessoryType: .phone),
                                RowViewModel(localizedLabel: .mobilePhoneLabel,
                                             valueProvider: self.user.phoneNumbers.cell,
                                             accessoryType: .phone)]))

        // - - - - - ADDRESS - - - - -
        sections.append(
            SectionViewModel(localizedTitle: .addressFieldLabel,
                             rowViewModels: [
                                RowViewModel(localizedLabel: .addressFieldLabel,
                                             valueProvider: self.formattedAddress()),
                                RowViewModel(localizedLabel: .countryFieldLabel,
                                             valueProvider: self.user.countryFlag + " " + self.localizedCountry)]))

        // - - - - - TIME ZONE - - - - -
        if let timezone = timezone {
            sections.append(
                SectionViewModel(localizedTitle: .timezoneFieldLabel,
                                 rowViewModels: [
                                    RowViewModel(localizedLabel: .timezoneFieldLabel,
                                                 valueProvider: timezone.identifier),
                                    RowViewModel(localizedLabel: .currentTimeFieldLabel,
                                                 valueProvider: self.formattedCurrentTime()
                                                        + "\n" + self.formattedCurrentDate(),
                                                 wantsPeriodicUpdate: true)]))
        }

        return sections
    }

    func loadImage(completion: @escaping (Result<UIImage, Error>) -> ()) -> Progress {
        return dataProvider.image(size: .large, for: user, completion: completion)
    }

    // MARK: - Private API

    private var localizedCountry: String {
        let isoCountryCode = user.nationality.isoCountryCode
        let locale = NSLocale.current
        return locale.localizedString(forRegionCode: isoCountryCode) ?? isoCountryCode
    }

    private var timezone: TimeZone? {
        return TimeZone(withOffset: user.location.timezoneOffset)
    }

    private func formattedAddress(formatter: CNPostalAddressFormatter = UserViewModel.defaultPostalAddressFormatter) -> String {
        return formatter.string(from: user.postalAddress)
    }

    private func formattedCurrentTime(for style: DateFormatter.Style = .medium) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.timeZone = timezone
        timeFormatter.timeStyle = .medium
        return timeFormatter.string(from: Date())
    }

    private func formattedCurrentDate(for style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timezone
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: Date())
    }

    // MARK: - Types

    enum AccessoryType {
        case email
        case phone
    }

    /// Represents a logical section of a user's data, replete with rows.
    struct SectionViewModel {
        let localizedTitle: LocalizedString
        let rowViewModels: [RowViewModel]
    }

    /// Represents a logical row of a user's data.
    struct RowViewModel {
        let localizedLabel: LocalizedString
        let valueProvider: () -> String
        let wantsPeriodicUpdate: Bool
        let accessoryType: AccessoryType?

        init(localizedLabel: LocalizedString,
             valueProvider: @escaping @autoclosure () -> String,
             wantsPeriodicUpdate: Bool = false,
             accessoryType: AccessoryType? = nil) {
            self.localizedLabel = localizedLabel
            self.valueProvider = valueProvider
            self.wantsPeriodicUpdate = wantsPeriodicUpdate
            self.accessoryType = accessoryType
        }
    }

    /// An `enum` representing entries in a localized string table. It's better
    /// than peppering calls to `NSLocalizedString(_, comment: _)` everywhere.
    enum LocalizedString {
        case usernameFieldLabel
        case emailFieldLabel
        case mobilePhoneLabel
        case homePhoneLabel
        case addressFieldLabel
        case countryFieldLabel
        case timezoneFieldLabel
        case currentTimeFieldLabel
        case contactSectionTitle
        case phoneSectionTitle
        case addressSectionTitle
        case timezoneSectionTitle

        case country(String)
        case notLocalized(String)

        var stringValue: String {
            switch self {
            case .usernameFieldLabel:
                return NSLocalizedString("Username", comment: "Username [Field Label]")
            case .emailFieldLabel:
                return NSLocalizedString("Email", comment: "Email [Field Label]")
            case .mobilePhoneLabel:
                return NSLocalizedString("Mobile", comment: "Mobile [Phone Number Field Label]")
            case .homePhoneLabel:
                return NSLocalizedString("Home", comment: "Home [Phone Number Field Label]")
            case .addressFieldLabel:
                return NSLocalizedString("Address", comment: "Address [Address Field Label]")
            case .countryFieldLabel:
                return NSLocalizedString("Country", comment: "Country [Address Field Label]")
            case .timezoneFieldLabel:
                return NSLocalizedString("Time Zone", comment: "Time Zone [Field Label]")
            case .currentTimeFieldLabel:
                return NSLocalizedString("Current Time", comment: "Current TIme [Field Label]")
            case .contactSectionTitle:
                return NSLocalizedString("Contact", comment: "Contact [Section Title]")
            case .phoneSectionTitle:
                return NSLocalizedString("Phone Numbers", comment: "Phone Numbers [Section Title]")
            case .addressSectionTitle:
                return NSLocalizedString("Address", comment: "Address [Section Title]")
            case .timezoneSectionTitle:
                return NSLocalizedString("Time Zone", comment: "Time Zone [Section Title]")
            case .country(let isoCountryCode):
                return NSLocale.current.localizedString(forRegionCode: isoCountryCode)!
            case .notLocalized(let string):
                return string
            }
        }
    }

}

extension UserViewModel: Equatable {

    static func == (lhs: UserViewModel, rhs: UserViewModel) -> Bool {
        return lhs.user == rhs.user
    }

}
