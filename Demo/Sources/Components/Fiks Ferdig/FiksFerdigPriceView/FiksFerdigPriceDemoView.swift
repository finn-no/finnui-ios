import FinniversKit
import FinnUI

final class FiksFerdigPriceDemoView: UIView, Tweakable {
    let priceView: FiksFerdigPriceView

    lazy var tweakingOptions: [TweakingOption] = [
        .init(title: "Normal shipping", description: nil, action: { [weak self] in
            var builder = FiksFerdigPriceViewModelBuilder()
            builder.shippingText = "+ frakt 80 kr"
            self?.priceView.viewModel = builder.build()
        }),
        .init(title: "Discounted shipping", description: nil, action: { [weak self] in
            var builder = FiksFerdigPriceViewModelBuilder()
            builder.priceText = .setPrice("80 Kr")
            self?.priceView.viewModel = builder.build()
        }),
        .init(title: "Price not set", description: nil, action: { [weak self] in
            var builder = FiksFerdigPriceViewModelBuilder()
            builder.priceText = .noPrice("Pris ikke satt")
            self?.priceView.viewModel = builder.build()
        }),
        .init(title: "Long shipping text", description: nil, action: { [weak self] in
            var builder = FiksFerdigPriceViewModelBuilder()
            builder.shippingText = "+ frakt <del>80</del> <span style=\"color:tjt-price-highlight\">60 kr</span> Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Nullam eget felis eget nunc lobortis."
            self?.priceView.viewModel = builder.build()
        }),
        .init(title: "Long payment info", description: nil, action: { [weak self] in
            var builder = FiksFerdigPriceViewModelBuilder()
            builder.paymentText = "Betal med kort eller Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Nullam eget felis eget nunc lobortis."
            self?.priceView.viewModel = builder.build()
        }),
    ]

    override init(frame: CGRect) {
        self.priceView = FiksFerdigPriceView(
            viewModel: FiksFerdigPriceViewModelBuilder().build(),
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

struct FiksFerdigPriceViewModelBuilder {
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
    var priceText: FiksFerdigPriceViewModel.PriceText = .setPrice("999 kr")
    var shippingText: String = "+ frakt <del>80</del> <span style=\"color:tjt-price-highlight\">60 kr</span>"
    var shippingAccessibilityText = "+ frakt"
    var paymentText: String = "Betal med kort eller"
    var paymentLogo: UIImage = UIImage(named: "vippsLogo")!
    var paymentLogoText: String = "Vipps"

    func build() -> FiksFerdigPriceViewModel {
        let paymentAttributedText = NSMutableAttributedString(string: "\(paymentText) ",
                                                              attributes: [.baselineOffset: 4])
        let logoAttachment = NSTextAttachment(image: paymentLogo)
        paymentAttributedText.append(NSAttributedString(attachment: logoAttachment))

        let attributedText = shippingText.attributedHTMLString(
            font: .bodyStrong,
            style: ["tjt-price-highlight": UIColor.cherry.hexString],
            textColor: .textPrimary.resolvedColor(with: .init(userInterfaceStyle: .light))
        )

        let darkModeAttributedText = shippingText.attributedHTMLString(
            font: .bodyStrong,
            style: ["tjt-price-highlight": UIColor.yellow.hexString],
            textColor: .textPrimary.resolvedColor(with: .init(userInterfaceStyle: .dark))
        )

        return FiksFerdigPriceViewModel(
            tradeType: tradeType,
            priceText: priceText,
            shipping: .init(
                text: attributedText,
                darkModeText: darkModeAttributedText,
                accessibilityText: shippingAccessibilityText
            ),
            payment: .init(
                text: paymentAttributedText,
                accessibilityText: "\(paymentText) \(paymentLogoText)"
            )
        )
    }
}
