//
// UIApplication.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import UIKit

extension UIApplication {

    var canOpenMailtoLinks: Bool {
        guard let url = URL(string: "mailto:") else {
            return false
        }
        return canOpenURL(url)
    }

    var canOpenTelLinks: Bool {
        guard let url = URL(string: "tel:") else {
            return false
        }
        return canOpenURL(url)
    }

}
