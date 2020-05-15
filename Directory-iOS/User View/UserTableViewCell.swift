//
// UserTableViewCell.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import UIKit

class UserTableViewCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var labelLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    // MARK: - Private Properties

    private var tapGestureRecognizer = UITapGestureRecognizer()

    // MARK: - Public Properties

    var accessory: TableViewCellAccessory? {
        didSet {
            accessoryDidChange(accessory)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        tapGestureRecognizer.addTarget(self,
                                       action: #selector(tapGestureRecognizerDidRecognize(_:)))
    }

    // MARK: - Private API

    private func accessoryDidChange(_ accessory: TableViewCellAccessory?) {
        guard let accessory = accessory else {
            accessoryView?.removeGestureRecognizer(tapGestureRecognizer)
            accessoryView = nil
            return
        }

        accessoryView = accessory.view
        accessory.view.isUserInteractionEnabled = true
        accessory.view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc
    func tapGestureRecognizerDidRecognize(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            accessory?.action()

        default:
            break
        }
    }

}
