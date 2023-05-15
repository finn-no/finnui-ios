import FinniversKit

public final class FiksFerdigPriceView: UIView {
    public var viewModel: FiksFerdigPriceViewModel {
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
        let stackView = UIStackView(axis: .vertical, withAutoLayout: true)
        stackView.alignment = .leading
        return stackView
    }()

    public init(viewModel: FiksFerdigPriceViewModel, withAutoLayout: Bool = false) {
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

        var hasPrice: Bool {
            if case .setPrice = viewModel.priceText {
                return true
            } else {
                return false
            }
        }

        if hasPrice {
            priceLabel.font = .title1
        } else {
            priceLabel.font = .title2Strong
        }

        tradeTypeLabel.isHidden = !hasPrice
        shippingLabel.isHidden = !hasPrice

        paymentLabel.attributedText = viewModel.payment.text
        priceLabel.accessibilityLabel = viewModel.priceString
        shippingLabel.accessibilityLabel = viewModel.shipping.accessibilityText
        paymentLabel.accessibilityLabel = viewModel.payment.accessibilityText
    }

    private func updateShippingLabel() {
        if traitCollection.userInterfaceStyle == .dark {
            shippingLabel.attributedText = viewModel.shipping.darkModeText
        } else {
            shippingLabel.attributedText = viewModel.shipping.text
        }
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        updateShippingLabel()
    }
}

extension UIColor {
    static let discountedPriceLabel = UIColor.dynamicColor(defaultColor: .cherry, darkModeColor: UIColor(hex: "#D91F0A"))
}
