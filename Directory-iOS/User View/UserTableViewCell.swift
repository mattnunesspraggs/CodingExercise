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

    // MARK: - UIView

    override func awakeFromNib() {
        super.awakeFromNib()
        tapGestureRecognizer.addTarget(self,
                                       action: #selector(tapGestureRecognizerDidRecognize(_:)))
    }

    // MARK: - Public Properties

    var viewModel: UserViewModel.RowViewModel? {
        didSet {
            if let viewModel = viewModel {
                viewModelDidChange(viewModel)
            }
        }
    }

    var accessory: TableViewCellAccessory? {
        didSet {
            accessoryDidChange(accessory)
        }
    }

    // MARK: - Private API

    private func accessoryView(with image: UIImage) -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        return imageView
    }

    private func viewModelDidChange(_ viewModel: UserViewModel.RowViewModel) {
        labelLabel.text = viewModel.localizedLabel.stringValue
        valueLabel.text = viewModel.valueProvider()
    }

    private func accessoryDidChange(_ accessory: TableViewCellAccessory?) {
        guard let accessory = accessory else {
            accessoryView?.removeGestureRecognizer(tapGestureRecognizer)
            accessoryView = nil
            return
        }

        accessoryView = accessoryView(with: accessory.image)
        accessoryView?.addGestureRecognizer(tapGestureRecognizer)
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
