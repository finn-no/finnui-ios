import FinniversKit
import FinnUI

final class TJTPriceDemoView: UIView {
    var viewModel: TJTPriceViewModel
    let priceView: TJTPriceView

    override init(frame: CGRect) {
        self.viewModel = TJTPriceViewModel(
            tradeType: "Til salgs",
            price: "999 kr",
            shipping: .init(text: "+ frakt", price: 40, originalPrice: 80),
            payment: "Betal med kort eller",
            priceFormatter: {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.maximumFractionDigits = 0
                formatter.allowsFloats = false
                formatter.groupingSize = 3
                formatter.groupingSeparator = " "
                return formatter
            }()
        )
        self.priceView = TJTPriceView(viewModel: viewModel, withAutoLayout: true)
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(priceView)

        NSLayoutConstraint.activate([
            priceView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingM),
            priceView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingM),
            priceView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingM)
        ])
    }
}
