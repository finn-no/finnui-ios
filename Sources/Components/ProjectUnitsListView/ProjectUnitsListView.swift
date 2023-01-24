import UIKit
import FinniversKit

public class ProjectUnitsListView: UIView {

    // MARK: - Public properties

    public var sorting: Column = .bedrooms {
        didSet { refreshUnits() }
    }

    // MARK: - Private properties

    private var viewModel: ViewModel?
    private var sortedUnits = [UnitItem]()
    private lazy var titleLabel = Label(style: .title3, numberOfLines: 0, withAutoLayout: true)
    private lazy var sortingLabel = Label(style: .body, numberOfLines: 0, withAutoLayout: true)
    private lazy var unitsStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(titleLabel)
        addSubview(unitsStackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            unitsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingM),
            unitsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            unitsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            unitsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - Public methods

    public func configure(with viewModel: ViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.titles.title
        sortingLabel.text = viewModel.titles.sortingTitle

        sortedUnits = sortUnits(units: viewModel.units, sorting: sorting)
        refreshUnits()
    }

    // MARK: - Private methods

    private func refreshUnits() {
        unitsStackView.removeArrangedSubviews()

        guard let viewModel = viewModel else { return }

        let headerRow = RowView(kind: .header, addSeparator: true, labelValue: { viewModel.columnHeadings.title(for: $0) })
        unitsStackView.addArrangedSubview(headerRow)

        let unitRows = sortedUnits.enumerated().map { index, unit in
            RowView(kind: .unit, addSeparator: true, labelValue: { unit.value(for: $0) })
        }
        unitsStackView.addArrangedSubviews(unitRows)
    }

    private func sortUnits(units: [UnitItem], sorting: Column) -> [UnitItem] {
        switch sorting {
        case .area:
            return units.sorted(by: { $0.area < $1.area })
        case .bedrooms:
            return units.sorted(by: { $0.bedrooms < $1.bedrooms })
        case .floor:
            return units.sorted(by: { $0.floor < $1.floor })
        case .name:
            return units.sorted(by: { $0.name < $1.name })
        case .totalPrice:
            return units.sorted(by: { $0.totalPrice < $1.totalPrice })
        }
    }
}
