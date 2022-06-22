import FinniversKit

public final class TJTPriceView: UIView {
    private lazy var tradeTypeLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.accessibilityTraits.insert(.header)
        label.numberOfLines = 0
        label.textColor = .licorice
        return label
    }()

    private lazy var priceLabel: Label = {
        let label = Label(style: .title1, withAutoLayout: true)
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.textColor = .licorice
        return label
    }()

    private lazy var shippingLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.isAccessibilityElement = false
        label.numberOfLines = 0
        label.textColor = .licorice
        return label
    }()

    private lazy var paymentLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.numberOfLines = 0
        label.textColor = .licorice
        return label
    }()

    private lazy var contentStackView = UIStackView(axis: .vertical, withAutoLayout: true)

    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, withAutoLayout: true)
        stackView.spacing = .spacingS
        stackView.alignment = .lastBaseline
        return stackView
    }()

    public var viewModel: TJTPriceViewModel {
        didSet {
            update()
        }
    }

    public init(viewModel: TJTPriceViewModel, withAutoLayout: Bool = false) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = !withAutoLayout

        addSubview(contentStackView)
        contentStackView.fillInSuperview(margin: .spacingS)

        contentStackView.addArrangedSubview(tradeTypeLabel)

        contentStackView.addArrangedSubview(priceStackView)
        priceStackView.addArrangedSubviews([priceLabel, shippingLabel])

        contentStackView.addArrangedSubview(paymentLabel)

        update()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func update() {
        tradeTypeLabel.text = viewModel.tradeType
        priceLabel.text = viewModel.price
        priceLabel.accessibilityLabel = "\(viewModel.price) \(viewModel.shippingAccessibilityText)"
        shippingLabel.attributedText = viewModel.shippingText
        paymentLabel.attributedText = viewModel.paymentInfoText(logoAlignedWithFont: paymentLabel.font)
        paymentLabel.accessibilityLabel = viewModel.paymentInfoAccessibilityText
    }
}
