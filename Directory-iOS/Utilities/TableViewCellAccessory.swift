//
// TableViewCellAccessory.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import UIKit

struct TableViewCellAccessory {
    let image: UIImage
    let action: () -> ()

    init(image: UIImage, action: @escaping () -> ()) {
        self.image = image
        self.action = action
    }
}
