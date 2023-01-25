import UIKit
import FinniversKit
import FinnUI

class ProjectUnitsListDemoView: UIView, DemoViewControllerSettable {

    // MARK: - Private properties

    weak var demoViewController: UIViewController?
    private var bottomSheet: BottomSheet?
    private var showSoldUnits = false
    private var sortOption = ProjectUnitsListView.Column.name
    private lazy var scrollView = UIScrollView(withAutoLayout: true)

    private lazy var projectUnitsListView: ProjectUnitsListView = {
        let view = ProjectUnitsListView(viewModel: .demoModel, delegate: self, withAutoLayout: true)
        view.configure(with: .demoModels(showSoldUnits: showSoldUnits), sorting: sortOption)
        view.configure(soldUnitsVisibilityButtonTitle: showSoldUnits.soldUnitsButtonTitle)
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        scrollView.alwaysBounceVertical = true
        scrollView.addSubview(projectUnitsListView)

        addSubview(scrollView)
        scrollView.fillInSuperview()

        NSLayoutConstraint.activate([
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            projectUnitsListView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: .spacingM),
            projectUnitsListView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: .spacingM),
            projectUnitsListView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -.spacingM),
            projectUnitsListView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -.spacingM)
        ])
    }

    // MARK: - Private methods

    private func sortUnits(
        units: [ProjectUnitsListView.UnitItem],
        sorting: ProjectUnitsListView.Column
    ) -> [ProjectUnitsListView.UnitItem] {
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
}

// MARK: - ProjectUnitsListViewDelegate

extension ProjectUnitsListDemoView: ProjectUnitsListViewDelegate {
    func projectUnitsListView(
        _ view: ProjectUnitsListView,
        wantsToPresentSortView sortView: UIView,
        fromSource source: UIView
    ) {
        bottomSheet?.state = .dismissed
        let bottomSheet = BottomSheet(view: sortView)
        demoViewController?.present(bottomSheet, animated: true)
        self.bottomSheet = bottomSheet
    }

    func projectUnitsListView(
        _ view: ProjectUnitsListView,
        didSelectSortOption sortOption: ProjectUnitsListView.Column
    ) {
        self.sortOption = sortOption
        view.configure(
            with: sortUnits(units: .demoModels(showSoldUnits: showSoldUnits), sorting: sortOption),
            sorting: sortOption
        )
        bottomSheet?.state = .dismissed
    }

    func projectUnitsListViewDidToggleSoldUnitsVisibility(_ view: ProjectUnitsListView) {
        showSoldUnits.toggle()
        view.configure(soldUnitsVisibilityButtonTitle: showSoldUnits.soldUnitsButtonTitle)
        view.configure(
            with: sortUnits(units: .demoModels(showSoldUnits: showSoldUnits), sorting: sortOption),
            sorting: sortOption
        )
    }
}

// MARK: - Private extensions

private extension Bool {
    var soldUnitsButtonTitle: String {
        self ? "Skjul solgte enheter" : "Vis solgte enheter"
    }
}

private extension ProjectUnitsListView.ViewModel {
    static var demoModel: ProjectUnitsListView.ViewModel {
        Self.init(
            titles: .demoModel,
            columnHeadings: .demoModel
        )
    }
}

private extension ProjectUnitsListView.Titles {
    static var demoModel: Self {
        Self.init(
            title: "Enheter i prosjektet",
            sortingTitle: "Sorter etter",
            hideSoldUnitsButtonTitle: "Skjul solgte enheter",
            showSoldUnitsButtonTitle: "Vis solgte enheter"
        )
    }
}

private extension ProjectUnitsListView.ColumnHeadings {
    static var demoModel: Self {
        Self.init(
            name: "Enhet",
            floor: "Etasje",
            bedrooms: "Soverom",
            area: "Areal",
            totalPrice: "Totalpris"
        )
    }
}

private extension Array where Element == ProjectUnitsListView.UnitItem {
    static func demoModels(showSoldUnits: Bool) -> [ProjectUnitsListView.UnitItem] {
        let areas = [100, 40, 2500, 1337, ].map { "\($0) m²" }
        let totalPrices = [450_000, 1_300_000, 9_999_999, 50_000, 666_000, 3_700_000]
            .compactMap { NumberFormatter.priceFormatter.string(from: NSNumber(value: $0)) }
            .map { "\($0) kr" }

        return (1...15).compactMap {
            let isSold = $0 % 2 == 0
            if isSold, !showSoldUnits { return nil }

            return ProjectUnitsListView.UnitItem(
                identifier: $0,
                name: "A \(100 + $0)",
                floor: "\(($0 * 2 % 15) + 1)",
                bedrooms: "\(($0 * 3 % 5) + 1)",
                area: areas[$0 % areas.count],
                totalPrice: isSold ? "Solgt" : totalPrices[$0 % totalPrices.count]
            )
        }
    }
}

private extension NumberFormatter {
    static var priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.allowsFloats = false
        formatter.groupingSize = 3
        formatter.groupingSeparator = " "
        return formatter
    }()
}
