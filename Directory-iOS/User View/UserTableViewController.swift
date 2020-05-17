//
// UserTableViewController.swift
// Copyright © 2020 Matt Nunes-Spraggs
//


import UIKit

class UserTableViewController: UITableViewController, UIStoryboardInstatiable {

    typealias SectionViewModel = UserViewModel.SectionViewModel

    // MARK: - Types

    private struct Constants {
        static let storyboardIdentifier = "UserTableViewController"
        static let detailCellIdentifier = "DetailCell"
        static let phoneAccessoryImage = UIImage(systemName: "phone.circle")!
        static let emailAccessoryImage = UIImage(systemName: "envelope")!
        static let userPlaceholderImage = UIImage(systemName: "person.fill")!
    }

    // MARK: - UIStoryboardInstantiable

    static var storyboardIdentifier: String { Constants.storyboardIdentifier }

    // MARK: - IBOutlets

    @IBOutlet weak var userImageView: UIImageView!

    // MARK: - Public Properties

    var userViewModel: UserViewModel? = nil {
        didSet {
            viewModelDidChange(userViewModel)
        }
    }

    // MARK: - Private Properties

    private var sectionViewModels: [SectionViewModel] = [] {
        didSet {
            sectionViewModelsDidChange(sectionViewModels)
        }
    }

    private var periodicUpdateTimer: Timer? = nil
    private var indexPathsWantingPeriodicReload: [IndexPath] = []
    private var avatarLoadingProgress: Progress? = nil {
        willSet {
            avatarLoadingProgress?.cancel()
        }
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        userImageView.layer.cornerRadius = 60
        userImageView.layer.borderColor = UIColor.systemGray5.cgColor
        userImageView.layer.borderWidth = 1
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startPeriodicUpdateTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopPeriodicUpdateTimer()
    }

    // MARK: - Private API

    private func viewModelDidChange(_ userViewModel: UserViewModel?) {
        navigationItem.title = userViewModel?.displayName ?? ""
        self.sectionViewModels = userViewModel?.sectionViewModels ?? []

        updateAvatarImage(Constants.userPlaceholderImage)
        self.avatarLoadingProgress = userViewModel?.loadImage { result in
            guard self.userViewModel == userViewModel else {
                return
            }
            _ = result.map { self.updateAvatarImage($0) }
        }
    }

    private func updateAvatarImage(_ image: UIImage) {
        guard Thread.current == Thread.main else {
            return DispatchQueue.main.sync {
                self.updateAvatarImage(image)
            }
        }

        self.userImageView.image = image
    }

    private func sectionViewModelsDidChange(_ sectionViewModels: [SectionViewModel]) {
        indexPathsWantingPeriodicReload = []
        tableView.reloadData()
    }

    private func emailAccessory(for email: String) -> TableViewCellAccessory? {
        guard UIApplication.shared.canOpenMailtoLinks else {
            return nil
        }

        return TableViewCellAccessory(image: Constants.emailAccessoryImage) {
            UIApplication.shared.openMailTo(email)
        }
    }

    private func phoneAccessory(for phoneNumber: String) -> TableViewCellAccessory? {
        guard UIApplication.shared.canOpenTelLinks else {
            return nil
        }

        return TableViewCellAccessory(image: Constants.phoneAccessoryImage) {
            UIApplication.shared.openTelTo(phoneNumber)
        }
    }

    private func startPeriodicUpdateTimer() {
        guard periodicUpdateTimer == nil else {
            return
        }
        self.periodicUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let selectedRows = self.tableView.indexPathsForSelectedRows
            self.tableView.reloadRows(at: self.indexPathsWantingPeriodicReload, with: .none)
            selectedRows?.forEach { indexPath in
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
    }

    private func stopPeriodicUpdateTimer() {
        periodicUpdateTimer?.invalidate()
        self.periodicUpdateTimer = nil
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionViewModels.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionViewModel = sectionViewModels[section]
        return sectionViewModel.rowViewModels.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionViewModel = sectionViewModels[section]
        return sectionViewModel.localizedTitle.stringValue
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.detailCellIdentifier,
                                                 for: indexPath) as! UserTableViewCell

        let sectionViewModel = sectionViewModels[indexPath.section]
        let rowViewModel = sectionViewModel.rowViewModels[indexPath.row]

        cell.viewModel = rowViewModel

        if rowViewModel.wantsPeriodicUpdate {
            indexPathsWantingPeriodicReload.append(indexPath)
        }

        cell.accessory = rowViewModel.accessoryType.flatMap { accessoryType -> TableViewCellAccessory? in
            let string = rowViewModel.valueProvider()
            switch accessoryType {
            case .email:
                return self.emailAccessory(for: string)

            case .phone:
                return self.phoneAccessory(for: string)
            }
        }

        return cell
    }

}
