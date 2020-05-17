//
// UIApplication.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import UIKit

extension UIApplication {

    /// Returns whether the app can open `"mailto:"` links.

    var canOpenMailtoLinks: Bool {
        guard let url = URL(string: "mailto:") else {
            return false
        }

        #if targetEnvironment(simulator)
        return false
        #else
        return canOpenURL(url)
        #endif
    }

    /// Returns whether the app can open `"tel:"` links.

    var canOpenTelLinks: Bool {
        guard let url = URL(string: "tel:") else {
            return false
        }

        #if targetEnvironment(simulator)
        return false
        #else
        return canOpenURL(url)
        #endif
    }

    /**
     Creates a `mailto:` link and asks the receiver to open it.

     - Parameter address: The email address with which to construct the URL.
     - Parameter options: A dictionary of options to use when opening the URL. For a list of possible keys to include in this dictionary, see `UIApplication.OpenExternalURLOptionsKey`.
     - Parameter completionHandler: The block to execute with the results. Provide a value for this parameter if you want to be informed of the success or failure of opening the URL. This block is executed asynchronously on your app's main thread. The block has no return value and takes the following parameter:
        - success: A `Bool` indicating whether the URL was opened successfully.
     */

    func openMailTo(_ address: String, options: [OpenExternalURLOptionsKey: Any] = [:], completionHandler: ((Bool) -> ())? = nil) {
        guard canOpenMailtoLinks, let url = URL(string: "mailto:\(address)") else {
            return
        }
        open(url, options: options, completionHandler: completionHandler)
    }

    /**
    Creates a `tel:` link and asks the receiver to open it.

    - Parameter number: The phone number with which to construct the URL.
    - Parameter options: A dictionary of options to use when opening the URL. For a list of possible keys to include in this dictionary, see `UIApplication.OpenExternalURLOptionsKey`.
    - Parameter completionHandler: The block to execute with the results. Provide a value for this parameter if you want to be informed of the success or failure of opening the URL. This block is executed asynchronously on your app's main thread. The block has no return value and takes the following parameter:
       - success: A `Bool` indicating whether the URL was opened successfully.
    */

    func openTelTo(_ number: String, options: [OpenExternalURLOptionsKey: Any] = [:], completionHandler: ((Bool) -> ())? = nil) {
        guard canOpenTelLinks, let url = URL(string: "tel:\(number)") else {
            return
        }
        open(url, options: options, completionHandler: completionHandler)
    }

}
