import UIKit
import FinniversKit

public protocol ProjectUnitsListViewDelegate: AnyObject {
    func projectUnitsListView(
        _ view: ProjectUnitsListView,
        wantsToPresentSortView sortView: UIView,
        fromSource source: UIView
    )

    func projectUnitsListView(
        _ view: ProjectUnitsListView,
        didSelectSortOption sortOption: ProjectUnitsListView.Column
    )

    func projectUnitsListViewDidToggleSoldUnitsVisibility(
        _ view: ProjectUnitsListView
    )
}

public class ProjectUnitsListView: UIView {

    // MARK: - Private properties

    private weak var delegate: ProjectUnitsListViewDelegate?
    private var viewModel: ViewModel
    private var units = [UnitItem]()
    private var sorting: Column = .name
    private lazy var titleLabel = Label(style: .title3, numberOfLines: 0, withAutoLayout: true)
    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
    private lazy var sortingStackView = UIStackView(axis: .horizontal, spacing: .spacingS, withAutoLayout: true)
    private lazy var sortingLabel = Label(style: .body, numberOfLines: 0, withAutoLayout: true)

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorInset = .zero
        tableView.isScrollEnabled = false
        tableView.register(UnitItemTableViewCell.self)
        return tableView
    }()

    private lazy var sortingIndicator: SortingIndicator = {
        let view = SortingIndicator(withAutoLayout: true)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectSorting)))
        return view
    }()

    private lazy var soldUnitsVisibilityButton: Button = {
        let button = Button(style: .default, size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(didSelectSoldUnitsVisibilityButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    // MARK: - Init

    public init(viewModel: ViewModel, delegate: ProjectUnitsListViewDelegate, withAutoLayout: Bool) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        titleLabel.text = viewModel.titles.title
        sortingLabel.text = viewModel.titles.sortingTitle

        let headerRow = RowView(kind: .header, addSeparator: true, labelValue: { column in
            viewModel.columnHeadings.title(for: column)
        })

        sortingStackView.addArrangedSubviews([sortingLabel, sortingIndicator, UIView(withAutoLayout: true), soldUnitsVisibilityButton])
        stackView.addArrangedSubviews([titleLabel, sortingStackView, headerRow])
        stackView.setCustomSpacing(.spacingM, after: sortingStackView)

        addSubview(stackView)
        addSubview(tableView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),

            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - Public methods

    public func configure(with units: [UnitItem], sorting: Column) {
        self.sorting = sorting
        sortingIndicator.configure(with: viewModel.columnHeadings.title(for: sorting))

        if units != self.units {
            self.units = units
            tableView.reloadData()
        }
    }

    public func configure(soldUnitsVisibilityButtonTitle title: String) {
        soldUnitsVisibilityButton.setTitle(title, for: .normal)
        soldUnitsVisibilityButton.isHidden = false
    }

    // MARK: - Overrides

    public override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let stackViewSize = stackView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        let tableViewHeight = units
            .map { unit -> CGFloat in
                let rowView = RowView(kind: .unit, labelValue: { unit.value(for: $0) })
                let size = rowView.systemLayoutSizeFitting(
                    targetSize,
                    withHorizontalFittingPriority: horizontalFittingPriority,
                    verticalFittingPriority: verticalFittingPriority
                )
                return size.height + (UnitItemTableViewCell.verticalSpacing * 2)
            }.reduce(0, +)

        return CGSize(
            width: targetSize.width,
            height: stackViewSize.height + tableViewHeight
        )
    }

    // MARK: - Actions

    @objc private func didSelectSorting() {
        let sortOptions = Column.allCases.map {
            SortView.SortOption(title: viewModel.columnHeadings.title(for: $0), column: $0, isSelected: sorting == $0)
        }

        let sortView = SortView(delegate: self, sortOptions: sortOptions)
        delegate?.projectUnitsListView(self, wantsToPresentSortView: sortView, fromSource: sortingIndicator)
    }

    @objc private func didSelectSoldUnitsVisibilityButton() {
        delegate?.projectUnitsListViewDidToggleSoldUnitsVisibility(self)
    }
}

// MARK: - UITableViewDataSource

extension ProjectUnitsListView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        units.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UnitItemTableViewCell.self, for: indexPath)

        let unit = units[indexPath.row]
        cell.configure(with: unit)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ProjectUnitsListView: UITableViewDelegate {
}

// MARK: - ProjectUnitsSortViewDelegate

extension ProjectUnitsListView: ProjectUnitsSortViewDelegate {
    func sortView(_ view: SortView, didSelectSortOption sortOption: Column) {
        delegate?.projectUnitsListView(self, didSelectSortOption: sortOption)
    }
}
