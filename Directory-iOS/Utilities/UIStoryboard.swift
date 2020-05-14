//
// UIStoryboard.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import UIKit

extension UIStoryboard {

    static let main: UIStoryboard = {
        return UIStoryboard(name: "Main", bundle: nil)
    }()

}

protocol UIStoryboardInstatiable {

    static var storyboard: UIStoryboard { get }
    static var storyboardIdentifier: String { get }

    static func instantiateFromStoryboard() -> Self

}

extension UIStoryboardInstatiable {

    static var storyboard: UIStoryboard { UIStoryboard.main }

    static func instantiateFromStoryboard() -> Self {
        return storyboard.instantiateViewController(identifier: storyboardIdentifier) as! Self
    }

}
