import UIKit
import FinniversKit

public class ProjectUnitsListView: UIView {

    // MARK: - Public properties

    public var sorting: Column = .bedrooms {
        didSet { refreshContent() }
    }

    // MARK: - Private properties

    private var viewModel: ViewModel?
    private var sortedUnits = [UnitItem]()
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

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        sortingStackView.addArrangedSubviews([sortingLabel, sortingIndicator])
        stackView.addArrangedSubviews([titleLabel, sortingStackView, unitsStackView])
        stackView.setCustomSpacing(.spacingM, after: sortingStackView)

        addSubview(stackView)
        stackView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(with viewModel: ViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.titles.title
        sortingLabel.text = viewModel.titles.sortingTitle

        refreshContent()
    }

    // MARK: - Private methods

    private func refreshContent() {
        unitsStackView.removeArrangedSubviews()

        guard let viewModel = viewModel else { return }

        sortedUnits = sortUnits(units: viewModel.units, sorting: sorting)
        sortingIndicator.configure(with: viewModel.columnHeadings.title(for: sorting))

        let headerRow = RowView(kind: .header, addSeparator: true, labelValue: { viewModel.columnHeadings.title(for: $0) })
        unitsStackView.addArrangedSubview(headerRow)

        let unitRows = sortedUnits.enumerated().map { index, unit in
            RowView(kind: .unit, addSeparator: true, labelValue: { unit.value(for: $0) })
        }
        unitsStackView.addArrangedSubviews(unitRows)
    }

    private func sortUnits(units: [UnitItem], sorting: Column) -> [UnitItem] {
        // The units should be sorted by the selected column, and then by name for units with equal values. 
        let sortedByName = units.sorted(by: { $0.name < $1.name })

        switch sorting {
        case .area:
            return sortedByName.sorted(by: { $0.area < $1.area })
        case .bedrooms:
            return sortedByName.sorted(by: { $0.bedrooms < $1.bedrooms })
        case .floor:
            return sortedByName.sorted(by: { $0.floor < $1.floor })
        case .totalPrice:
            return sortedByName.sorted(by: { $0.totalPrice < $1.totalPrice })
        case .name:
            return sortedByName
        }
    }

    // MARK: - Actions

    @objc private func didSelectSorting() {
    }
}

// MARK: - ProjectUnitsSortViewDelegate

extension ProjectUnitsListView: ProjectUnitsSortViewDelegate {
    func sortView(_ view: SortView, didSelectSortOption sortOption: Column) {
    }
}
