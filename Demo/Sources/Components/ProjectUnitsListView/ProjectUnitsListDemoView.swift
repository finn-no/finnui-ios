import UIKit
import FinniversKit
import FinnUI

class ProjectUnitsListDemoView: UIView, DemoViewControllerSettable {

    // MARK: - Private properties

    weak var demoViewController: UIViewController?
    private lazy var scrollView = UIScrollView(withAutoLayout: true)

    private lazy var projectUnitsListView: ProjectUnitsListView = {
        let view = ProjectUnitsListView(withAutoLayout: true)
        view.configure(with: .demoModel)
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
}

// MARK: - Private extensions

private extension ProjectUnitsListView.ViewModel {
    static var demoModel: ProjectUnitsListView.ViewModel {
        Self.init(
            titles: .demoModel,
            columnHeadings: .demoModel,
            units: .demoModels
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
    static var demoModels: [ProjectUnitsListView.UnitItem] {
        let areas = [100, 40, 2500, 1337, ].map { "\($0) m²" }
        let totalPrices = [450_000, 1_300_000, 9_999_999, 50_000, 666_000, 3_700_000]
            .compactMap { NumberFormatter.priceFormatter.string(from: NSNumber(value: $0)) }
            .map { "\($0) kr" }

        return (1...15).map {
            ProjectUnitsListView.UnitItem(
                identifier: $0,
                name: "A \(100 + $0)",
                floor: "\(($0 * 2 % 15) + 1)",
                bedrooms: "\(($0 * 3 % 5) + 1)",
                area: areas[$0 % areas.count],
                totalPrice: totalPrices[$0 % totalPrices.count],
                isSold: $0 % 2 == 0
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
