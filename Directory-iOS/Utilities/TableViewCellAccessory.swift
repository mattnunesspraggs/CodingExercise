//
// TableViewCellAccessory.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import UIKit

struct TableViewCellAccessory {
    let view: UIView
    let action: () -> ()

    init(view: UIView, action: @escaping () -> ()) {
        self.view = view
        self.action = action
    }
}
