//
// UserSearchTableViewCell.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import UIKit

/**
 A `UITableViewCell` subclass representing a row in the user search results.

 This cell is entirely laid out (including Autolayout constraints) in code,
 to demonstrate what it can look like. Normally, I'd do it in a Storyboard,
 but this isn't so bad - it's certainly easier to collaborate on and to
 track changes over time in.
 */

class UserSearchTableViewCell: UITableViewCell {

    // MARK: - Constants

    private struct Constants {
        static let avatarImageHeight: CGFloat = 32
        static let avatarImageCornerRadius: CGFloat = (avatarImageHeight / 4)
        static let displayNameLabelColor: UIColor = .label
        static let displayNameLabelFont: UIFont = .boldSystemFont(ofSize: UIFont.systemFontSize)
        static let usernameLabelColor: UIColor = .secondaryLabel
        static let usernameLabelFont: UIFont = .systemFont(ofSize: UIFont.systemFontSize, weight: .light)
    }

    // MARK: - Private Properties

    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = Constants.usernameLabelColor
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Constants.avatarImageCornerRadius
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var displayNameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.displayNameLabelFont
        label.textColor = Constants.displayNameLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.usernameLabelFont
        label.textColor = Constants.usernameLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Public Properties

    var viewModel: UserSearchCellViewModel? = nil {
        didSet {
            if let viewModel = viewModel {
                viewModelDidChange(viewModel)
            }
        }
    }

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private API

    private func setupSubviews() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(displayNameLabel)
        contentView.addSubview(usernameLabel)
        setupConstraints()
    }

    private func setupConstraints() {
        let avatarHeightConstraint = avatarImageView.heightAnchor.constraint(equalToConstant: Constants.avatarImageHeight)
        avatarHeightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            avatarHeightConstraint,
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor, multiplier: 1, constant: 0),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: separatorInset.left),
            avatarImageView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: avatarImageView.bottomAnchor, multiplier: 1),

            displayNameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: avatarImageView.trailingAnchor, multiplier: 1),
            displayNameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            displayNameLabel.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            contentView.bottomAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: displayNameLabel.bottomAnchor, multiplier: 1),

            usernameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: displayNameLabel.trailingAnchor, multiplier: 1),
            usernameLabel.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            usernameLabel.centerYAnchor.constraint(equalTo: displayNameLabel.centerYAnchor),
            contentView.bottomAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: usernameLabel.bottomAnchor, multiplier: 1),
            contentView.trailingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: usernameLabel.trailingAnchor, multiplier: 1)
        ])
    }

    private func viewModelDidChange(_ viewModel: UserSearchCellViewModel) {
        displayNameLabel.text = viewModel.displayName
        usernameLabel.text = viewModel.username
    }

}
