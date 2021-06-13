// BonusIncreaseRateDataSource.swift
// Copyright © PJSC Bank Otkritie. All rights reserved.

import DifferenceKit
import UIKit

// MARK: - Constants

private extension Constants {
    /// Высота хедера
    static let headerHeight: CGFloat = 50
}

/// Описывает основные методы, которые должны обрабатываться Responder
protocol PlantTableViewDataSourceEventsRespondable: NSObject {
    func didSelectRow(index: Int)
}

/// DataSource для экрана повышения ставки
final class PlantTableViewDataSource: NSObject {
    // MARK: - Private Properties

    private weak var tableView: UITableView?
    private var rows: [Row] = []
    weak var delegate: PlantTableViewDataSourceEventsRespondable?

    // MARK: - Public Methods
    
    override init() {}

    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        setupTableView()
    }

    func update(with rows: [Row]) {
        guard let tableView = tableView else { return }
        tableView.reloadData()
        if self.rows.isEmpty {
            self.rows = rows
            tableView.reloadData()
        } else {
            let changeSet = StagedChangeset(source: self.rows, target: rows)
            tableView.reload(
                using: changeSet,
                deleteSectionsAnimation: .fade,
                insertSectionsAnimation: .fade,
                reloadSectionsAnimation: .fade,
                deleteRowsAnimation: .fade,
                insertRowsAnimation: .fade,
                reloadRowsAnimation: .fade
            ) { [weak self] data in
                self?.rows = data
            }
        }
    }

    // MARK: - Private Methods

    private func setupTableView() {
        guard let tableView = tableView else { return }
        tableView.delegate = self
        tableView.register(PlantTitleTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }
}

// MARK: - Row

extension PlantTableViewDataSource {
    enum Row: Equatable, Differentiable {
        case plants(PlantTitleTableViewCell.ViewModel)

        var differenceIdentifier: AnyHashable {
            switch self {
            case let .plants(viewModel):
                return viewModel
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension PlantTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        switch row {
        case let .plants(viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? PlantTitleTableViewCell else { return UITableViewCell() }
            cell.configure(with: viewModel)
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension PlantTableViewDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case .zero:
            let row = rows[indexPath.row]
            switch row {
            case let .plants(viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? PlantTitleTableViewCell
                cell?.rotateArrowAnimated(isSelecting: viewModel.isExpanded)
                
            }
            delegate?.didSelectRow(index: indexPath.row)
        default:
            return
        }
    }
}
