//
// TableViewCellAccessory.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import UIKit

/**
 A class representing an accessory in a `UITableViewCell`
 */

struct TableViewCellAccessory {

    /// The accessory's image, to be displayed in the cell.
    let image: UIImage

    /// The action to be run when the accessory is triggered.
    let action: () -> ()

    /**
     Instantiates a `TableViewCellAccessory`.

     - Parameter image: The accessory's image, to be displayed in the cell
     - Parameter action: The action to be run when the accessory is triggered.
     */
    init(image: UIImage, action: @escaping () -> ()) {
        self.image = image
        self.action = action
    }
}
