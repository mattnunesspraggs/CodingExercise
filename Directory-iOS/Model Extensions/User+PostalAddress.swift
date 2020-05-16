//
// User+PostalAddress.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import Foundation
import Contacts

extension User {

    /// The `User`'s address as an instance of `CNPostalAddress`.
    var postalAddress: CNPostalAddress {
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
