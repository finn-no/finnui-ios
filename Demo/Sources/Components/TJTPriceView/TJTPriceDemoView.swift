import FinniversKit
import FinnUI

final class TJTPriceDemoView: UIView, Tweakable {
    let priceView: TJTPriceView

    lazy var tweakingOptions: [TweakingOption] = [
        .init(title: "Normal shipping", description: nil, action: { [weak self] in
            self?.priceView.viewModel = TJTPriceViewModelBuilder().build()
        }),
        .init(title: "Discounted shipping", description: nil, action: { [weak self] in
            var builder = TJTPriceViewModelBuilder()
            builder.shippingOriginalPrice = 80
            self?.priceView.viewModel = builder.build()
        }),
        .init(title: "Long shipping text", description: nil, action: { [weak self] in
            var builder = TJTPriceViewModelBuilder()
            builder.shippingText = [String](repeating: builder.shippingText, count: 10)
                .joined(separator: " ")
            self?.priceView.viewModel = builder.build()
        }),
        .init(title: "Long payment info", description: nil, action: { [weak self] in
            var builder = TJTPriceViewModelBuilder()
            builder.paymentText = [String](repeating: builder.paymentText, count: 4)
                .joined(separator: " ")
            self?.priceView.viewModel = builder.build()
        }),
    ]

    override init(frame: CGRect) {
        self.priceView = TJTPriceView(
            viewModel: TJTPriceViewModelBuilder().build(),
            withAutoLayout: true
        )
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

struct TJTPriceViewModelBuilder {
    let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.allowsFloats = false
        formatter.groupingSize = 3
        formatter.groupingSeparator = " "
        return formatter
    }()

    let priceAccessibilityFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.allowsFloats = false
        formatter.groupingSize = 0
        formatter.groupingSeparator = ""
        return formatter
    }()

    var tradeType: String = "Til salgs"
    var price: String = "999 kr"
    var shippingText: String = "+ frakt"
    var shippingPrice: Double = 40
    var shippingOriginalPrice: Double?
    var paymentText: String = "Betal med kort eller"

    func build() -> TJTPriceViewModel {
        return TJTPriceViewModel(
            tradeType: tradeType,
            price: price,
            shipping: .init(
                text: shippingText,
                price: shippingPrice,
                originalPrice: shippingOriginalPrice
            ),
            paymentInfo: paymentText,
            priceFormatter: priceFormatter,
            priceAccessibilityFormatter: priceAccessibilityFormatter
        )
    }
}
