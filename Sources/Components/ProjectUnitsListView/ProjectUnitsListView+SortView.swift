import FinniversKit

protocol ProjectUnitsSortViewDelegate: AnyObject {
    func sortView(_ view: ProjectUnitsListView.SortView, didSelectSortOption sortOption: ProjectUnitsListView.Column)
}

extension ProjectUnitsListView {
    class SortView: UIView {

        // MARK: - Private Properties

        private weak var delegate: ProjectUnitsSortViewDelegate?
        private var sortOptions = [SortOption]()
        private lazy var impactGenerator = UIImpactFeedbackGenerator(style: .medium)

        private lazy var tableView: UITableView = {
            let tableView = UITableView(frame: .zero, style: .plain)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.backgroundColor = .bgBottomSheet
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = 48
            tableView.tableFooterView = UIView()
            tableView.alwaysBounceVertical = false
            tableView.register(RadioButtonTableViewCell.self)
            return tableView
        }()

        // MARK: - Init

        init(delegate: ProjectUnitsSortViewDelegate?, sortOptions: [SortOption]) {
            self.delegate = delegate
            self.sortOptions = sortOptions
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false

            setup()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: - Setup

        private func setup() {
            addSubview(tableView)
            tableView.fillInSuperview()
        }
    }
}

// MARK: - UITableViewDelegate

extension ProjectUnitsListView.SortView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        impactGenerator.prepare()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            !sortOptions[indexPath.row].isSelected,
            let cell = tableView.cellForRow(at: indexPath) as? RadioButtonTableViewCell
        else { return }

        sortOptions[indexPath.row].isSelected = true
        cell.animateSelection(isSelected: true)
        impactGenerator.impactOccurred()
        delegate?.sortView(self, didSelectSortOption: sortOptions[indexPath.row].column)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RadioButtonTableViewCell else {
            return
        }

        sortOptions[indexPath.row].isSelected = false
        cell.animateSelection(isSelected: false)
    }
}

// MARK: - UITableViewDataSource

extension ProjectUnitsListView.SortView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RadioButtonTableViewCell.self, for: indexPath)
        let isLastCell = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        let model = sortOptions[indexPath.row]

        cell.backgroundColor = .bgBottomSheet
        cell.configure(with: model)

        if isLastCell {
            cell.separatorInset = .leadingInset(.greatestFiniteMagnitude)
        }

        return cell
    }
}

// MARK: - Internal types

extension ProjectUnitsListView.SortView {
    struct SortOption: SelectableTableViewCellViewModel {
        let title: String
        let subtitle: String? = nil
        let detailText: String? = nil
        let hasChevron = false
        let column: ProjectUnitsListView.Column
        var isSelected: Bool = false

        internal init(title: String, column: ProjectUnitsListView.Column, isSelected: Bool = false) {
            self.title = title
            self.column = column
            self.isSelected = isSelected
        }
    }
}
