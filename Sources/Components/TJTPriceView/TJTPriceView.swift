import FinniversKit
import UIKit

public struct TJTPriceViewModel {
    public let tradeType: String
    public let price: String
    public let shipping: String
    public let payment: String

    public init(
        tradeType: String,
        price: String,
        shipping: String,
        payment: String
    ) {
        self.tradeType = tradeType
        self.price = price
        self.shipping = shipping
        self.payment = payment
    }
}

public final class TJTPriceView: UIView {
    private lazy var tradeTypeLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.textColor = .licorice
        return label
    }()

    private lazy var priceLabel: Label = {
        let label = Label(style: .title1, withAutoLayout: true)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.textColor = .licorice
        return label
    }()

    private lazy var shippingLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.textColor = .licorice
        return label
    }()

    private lazy var paymentLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
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
            configure(with: viewModel)
        }
    }

    public init(viewModel: TJTPriceViewModel, withAutoLayout: Bool = false) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = !withAutoLayout

        addSubview(contentStackView)
        contentStackView.fillInSuperview(margin: .spacingS)

        contentStackView.addArrangedSubview(tradeTypeLabel)

        priceStackView.addArrangedSubviews([priceLabel, shippingLabel])
        contentStackView.addArrangedSubview(priceStackView)

        contentStackView.addArrangedSubview(paymentLabel)

        configure(with: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(with viewModel: TJTPriceViewModel) {
        tradeTypeLabel.text = viewModel.tradeType
        priceLabel.text = viewModel.price
        shippingLabel.text = viewModel.shipping
        paymentLabel.text = viewModel.payment
    }
}
