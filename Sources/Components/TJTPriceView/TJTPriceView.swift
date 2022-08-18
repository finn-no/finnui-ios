import FinniversKit

public final class TJTPriceView: UIView {
    public var viewModel: TJTPriceViewModel {
        didSet {
            update()
        }
    }

    private lazy var tradeTypeLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.accessibilityTraits.insert(.header)
        label.numberOfLines = 0
        label.textColor = .textPrimary
        return label
    }()

    private lazy var priceLabel: Label = {
        let label = Label(style: .title1, withAutoLayout: true)
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.textColor = .textPrimary
        return label
    }()

    private lazy var shippingLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.isAccessibilityElement = false
        label.numberOfLines = 0
        label.textColor = .textPrimary
        return label
    }()

    private lazy var paymentLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.numberOfLines = 0
        label.textColor = .textPrimary
        return label
    }()

    private lazy var contentStackView = UIStackView(axis: .vertical, withAutoLayout: true)

    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, withAutoLayout: true)
        stackView.spacing = .spacingS
        stackView.alignment = .firstBaseline
        return stackView
    }()

    public init(viewModel: TJTPriceViewModel, withAutoLayout: Bool = false) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = !withAutoLayout

        addSubview(contentStackView)
        contentStackView.fillInSuperview()

        contentStackView.addArrangedSubview(tradeTypeLabel)

        contentStackView.addArrangedSubview(priceStackView)
        priceStackView.addArrangedSubviews([priceLabel, shippingLabel])

        contentStackView.addArrangedSubview(paymentLabel)

        update()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func update() {
        tradeTypeLabel.text = viewModel.tradeType
        priceLabel.text = viewModel.priceString
        updateShippingLabel()
        if case .noPrice = viewModel.priceText {
            priceLabel.font = .title2Strong
        } else {
            priceLabel.font = .title1
        }
        paymentLabel.attributedText = viewModel.payment.text
        priceLabel.accessibilityLabel = viewModel.shippingAccessibilityLabel
        paymentLabel.accessibilityLabel = viewModel.payment.accessibilityText
    }

    private func updateShippingLabel() {
        shippingLabel.textColor = .textPrimary
        let style = ["tjt-price-highlight": UIColor.discountedPriceLabel.hexString]
        shippingLabel.setText(
            fromHTMLString: viewModel.shipping.text,
            style: style
        )
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // This has to be dispatched to the main thread.
        // https://stackoverflow.com/questions/46881393/ios-crash-report-unexpected-start-state-exception
        DispatchQueue.main.async {
            self.updateShippingLabel()
        }
    }
}

extension UIColor {
    static let discountedPriceLabel = UIColor.dynamicColor(defaultColor: .cherry, darkModeColor: UIColor(hex: "#D91F0A"))
}
