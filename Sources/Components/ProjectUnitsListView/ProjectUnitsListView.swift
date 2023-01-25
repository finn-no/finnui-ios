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
    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
    private lazy var titleLabel = Label(style: .title3, numberOfLines: 0, withAutoLayout: true)
    private lazy var sortingStackView = UIStackView(axis: .horizontal, spacing: .spacingS, withAutoLayout: true)
    private lazy var sortingLabel = Label(style: .body, numberOfLines: 0, withAutoLayout: true)
    private lazy var unitsStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)

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

        sortingStackView.addArrangedSubviews([sortingLabel, sortingIndicator, UIView(withAutoLayout: true), soldUnitsVisibilityButton])
        stackView.addArrangedSubviews([titleLabel, sortingStackView, unitsStackView])
        stackView.setCustomSpacing(.spacingM, after: sortingStackView)

        addSubview(stackView)
        stackView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(with units: [UnitItem], sorting: Column) {
        self.sorting = sorting
        self.units = units

        unitsStackView.removeArrangedSubviews()

        sortingIndicator.configure(with: viewModel.columnHeadings.title(for: sorting))

        let headerRow = RowView(kind: .header, addSeparator: true, labelValue: { viewModel.columnHeadings.title(for: $0) })
        unitsStackView.addArrangedSubview(headerRow)

        let unitRows = units.enumerated().map { index, unit in
            RowView(kind: .unit, addSeparator: true, labelValue: { unit.value(for: $0) })
        }
        unitsStackView.addArrangedSubviews(unitRows)
    }

    public func configure(soldUnitsVisibilityButtonTitle title: String) {
        soldUnitsVisibilityButton.setTitle(title, for: .normal)
        soldUnitsVisibilityButton.isHidden = false
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

// MARK: - ProjectUnitsSortViewDelegate

extension ProjectUnitsListView: ProjectUnitsSortViewDelegate {
    func sortView(_ view: SortView, didSelectSortOption sortOption: Column) {
        delegate?.projectUnitsListView(self, didSelectSortOption: sortOption)
    }
}
