//
// UserTableViewController.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import UIKit

class UserTableViewController: UITableViewController, UIStoryboardInstatiable {

    // MARK: - Types

    private struct Constants {
        static let storyboardIdentifier = "UserTableViewController"
        static let detailCellIdentifier = "DetailCell"
    }

    private enum AccessoryIcon: String {
        case phone = "phone.circle"
        case email = "envelope"
    }

    // MARK: - UIStoryboardInstantiable

    static var storyboardIdentifier: String { Constants.storyboardIdentifier }

    // MARK: - Public Properties

    var userViewModel: UserViewModel? = nil {
        didSet {
            navigationItem.title = userViewModel?.displayName ?? ""
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let userViewModel = userViewModel {
            self.sections = tableViewSections(forViewModel: userViewModel)
            tableView.reloadData()
        }
    }

    // MARK: - Private Properties

    private var sections: [Section] = []

    // MARK: - Private API

    private func accessoryView(for accessory: AccessoryIcon) -> UIView {
        let imageView = UIImageView(frame: .init(x: 0, y: 0, width: 24, height: 24))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: accessory.rawValue)
        return imageView
    }

    private func row(for phoneNumber: UserViewModel.PhoneNumber) -> Row {
        switch phoneNumber {
        case .cell(let number):
            return Row(label: .mobilePhoneLabel, value: number,
                       accessory: phoneAccessory(for: number))

        case .home(let number):
            return Row(label: .homePhoneLabel, value: number,
                       accessory: phoneAccessory(for: number))

        case .other(let label, let number):
            return Row(label: label, value: number,
                       accessory: phoneAccessory(for: number))
        }
    }

    private func countryString(forViewModel viewModel: UserViewModel) -> String {
        return viewModel.countryFlag + " " + LocalizedString.country(viewModel.isoCountryCode).stringValue
    }

    private func tableViewSections(forViewModel viewModel: UserViewModel) -> [Section] {
        return [
            Section(title: .contactSectionTitle,
                    rows: [
                        Row(label: .usernameFieldLabel,
                            value: viewModel.username),
                        Row(label: .emailFieldLabel,
                            value: viewModel.email,
                            accessory: emailAccessory(for: viewModel.email))]),
            Section(title: .phoneSectionTitle,
                    rows: viewModel.phoneNumbers.map { row(for: $0) }),
            Section(title: .addressSectionTitle,
                    rows: [
                        Row(label: .addressFieldLabel,
                            value: viewModel.formattedAddress),
                        Row(label: .countryFieldLabel,
                            value: countryString(forViewModel: viewModel))])
        ]
    }

    private func emailAccessory(for email: String) -> TableViewCellAccessory? {
        guard UIApplication.shared.canOpenMailtoLinks else {
            return nil
        }

        return TableViewCellAccessory(view: accessoryView(for: .email)) {
            guard let url = URL(string: "mailto:\(email)") else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    private func phoneAccessory(for phoneNumber: String) -> TableViewCellAccessory? {
        guard UIApplication.shared.canOpenTelLinks else {
            return nil
        }

        return TableViewCellAccessory(view: accessoryView(for: .phone)) {
            guard let url = URL(string: "tel:\(phoneNumber)") else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.detailCellIdentifier, for: indexPath) as! UserTableViewCell

        let section = sections[indexPath.section]
        let row = section.rows[indexPath.row]

        cell.labelLabel.text = row.label
        cell.valueLabel.text = row.value
        cell.accessory = row.accessory

        return cell
    }

}

extension UserTableViewController {

    fileprivate struct Row {
        let label: String
        let value: String
        let accessory: TableViewCellAccessory?

        init(label: LocalizedString, value: String,
             accessory: TableViewCellAccessory? = nil) {
            self.label = label.stringValue
            self.value = value
            self.accessory = accessory
        }

        init(label: String, value: String,
             accessory: TableViewCellAccessory? = nil) {
            self.label = label
            self.value = value
            self.accessory = accessory
        }
    }

    fileprivate struct Section {
        let title: String
        let rows: [Row]

        init(title: LocalizedString, rows: [Row]) {
            self.title = title.stringValue
            self.rows = rows
        }
    }

}

fileprivate enum LocalizedString {
    case usernameFieldLabel
    case emailFieldLabel
    case mobilePhoneLabel
    case homePhoneLabel
    case addressFieldLabel
    case countryFieldLabel
    case contactSectionTitle
    case phoneSectionTitle
    case addressSectionTitle

    case country(String)

    var stringValue: String {
        switch self {
        case .usernameFieldLabel:
            return NSLocalizedString("Username", comment: "Username [Field Label]")
        case .emailFieldLabel:
            return NSLocalizedString("Email", comment: "Email [Field Label]")
        case .mobilePhoneLabel:
            return NSLocalizedString("Mobile", comment: "Mobile [Phone Number Field Label]")
        case .homePhoneLabel:
            return NSLocalizedString("Home", comment: "Home [Phone Number Field Label]")
        case .addressFieldLabel:
            return NSLocalizedString("Address", comment: "Address [Address Field Label]")
        case .countryFieldLabel:
            return NSLocalizedString("Country", comment: "Country [Address Field Label]")
        case .contactSectionTitle:
            return NSLocalizedString("Contact", comment: "Contact [Section Title]")
        case .phoneSectionTitle:
            return NSLocalizedString("Phone Numbers", comment: "Phone Numbers [Section Title]")
        case .addressSectionTitle:
            return NSLocalizedString("Address", comment: "Address [Section Title]")
        case .country(let isoCountryCode):
            return NSLocale.current.localizedString(forRegionCode: isoCountryCode)!
        }
    }
}
