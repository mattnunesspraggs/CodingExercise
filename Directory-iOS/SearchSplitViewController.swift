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
        return true
    }

}
