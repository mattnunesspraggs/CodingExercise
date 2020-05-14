//
// SearchSplitViewController.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import UIKit

class SearchSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self

        preferredDisplayMode = .allVisible
    }

}

extension SearchSplitViewController: UISplitViewControllerDelegate {

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        guard let secondaryNavigationController = secondaryViewController as? UINavigationController else {
            return false
        }

        // Collapse the secondary onto the primary when there are no view controllers
        // in the secondary's stack (apart from the root view controller, which is a placeholder)
        return secondaryNavigationController.viewControllers.count == 1
    }

}
