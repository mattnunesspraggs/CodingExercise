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

    func openMailTo(_ address: String, options: [OpenExternalURLOptionsKey: Any] = [:], completionHandler: ((Bool) -> ())? = nil) {
        guard canOpenMailtoLinks, let url = URL(string: "mailto:\(address)") else {
            return
        }
        open(url, options: options, completionHandler: completionHandler)
    }

    func openTelTo(_ number: String, options: [OpenExternalURLOptionsKey: Any] = [:], completionHandler: ((Bool) -> ())? = nil) {
        guard canOpenTelLinks, let url = URL(string: "tel:\(number)") else {
            return
        }
        open(url, options: options, completionHandler: completionHandler)
    }

}
