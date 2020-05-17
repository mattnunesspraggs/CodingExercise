//
// UIStoryboard.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import UIKit

extension UIStoryboard {

    /// The main storyboard, i.e. with the name `"Main"`.

    static let main: UIStoryboard = {
        return UIStoryboard(name: "Main", bundle: nil)
    }()

}

protocol UIStoryboardInstatiable {

    /// The `UIStoryboard` from which to instantiate the receiver.
    static var storyboard: UIStoryboard { get }

    /// The `UIStoryboard` identifier with which to instantiate the receiver.
    static var storyboardIdentifier: String { get }

    /// Returns an instance of the receiver instantiated from
    /// `self.storyboard` with `self.storyboardIdentifier`.
    static func instantiateFromStoryboard() -> Self

}

extension UIStoryboardInstatiable {

    static var storyboard: UIStoryboard { UIStoryboard.main }

    static func instantiateFromStoryboard() -> Self {
        return storyboard.instantiateViewController(identifier: storyboardIdentifier) as! Self
    }

}
