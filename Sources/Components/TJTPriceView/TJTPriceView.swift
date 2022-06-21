import FinniversKit
import UIKit

public struct TJTPriceViewModel {
    public struct Shipping {
        public let text: String
        public let price: Double
        public let originalPrice: Double?

        public init(
            text: String,
            price: Double,
            originalPrice: Double?
        ) {
            self.text = text
            self.price = price
            self.originalPrice = originalPrice
        }
    }

    public let tradeType: String
    public let price: String
    public let shipping: Shipping
    public let payment: String
    public let priceFormatter: NumberFormatter

    public init(
        tradeType: String,
        price: String,
        shipping: Shipping,
        payment: String,
        priceFormatter: NumberFormatter
    ) {
        self.tradeType = tradeType
        self.price = price
        self.shipping = shipping
        self.payment = payment
        self.priceFormatter = priceFormatter
    }

    public var shippingText: NSAttributedString {
        let text = NSMutableAttributedString(string: shipping.text + " ")
        if let originalPrice = shipping.originalPrice {
            let shippingPriceText = formatCurrency(shipping.price)
            let coloredShippingPrice = NSAttributedString(string: shippingPriceText, attributes: [
                .foregroundColor: UIColor.cherry
            ])
            text.append(coloredShippingPrice)

            text.append(NSAttributedString(string: " "))
            let originalPriceText = formatCurrency(originalPrice)
            let coloredOriginalPrice = NSAttributedString(string: originalPriceText, attributes: [
                .foregroundColor: UIColor.stone,
                .strikethroughColor: UIColor.stone,
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ])
            text.append(coloredOriginalPrice)
        } else {
            let shippingPriceText = formatCurrency(shipping.price)
            text.append(NSAttributedString(string: shippingPriceText))
        }

        return text
    }

    public func paymentInfoText(logoAlignedWithFont font: UIFont) -> NSAttributedString {
        let text = NSMutableAttributedString(string: payment + " ")
        let logo = UIImage(named: .vippsLogo)
        let logoAspect = logo.size.width / logo.size.height
        let logoAttachment = NSTextAttachment(image: logo)
        let lineAscentAndDescent = font.ascender + font.descender
        // Since we don't have a baseline for the logo we must calculate the correct alignment and
        // size based on the font the text in front of the logo uses. The ascent and the descent added
        // together is the maximum character height available. The logo y position is set to the
        // descender to align with the baseline. The descender offset is necessary since the font in the
        // logo is different so the alignment is slightly off, and was found using 12 pt font as reference.
        let descenderOffset = font.pointSize / 12
        var logoBounds = logoAttachment.bounds
        logoBounds.origin.y = font.descender + descenderOffset
        logoBounds.size = CGSize(width: lineAscentAndDescent * logoAspect, height: lineAscentAndDescent)
        logoAttachment.bounds = logoBounds
        text.append(NSAttributedString(attachment: logoAttachment))
        return text
    }

    private func formatCurrency(_ value: Double) -> String {
        guard let formattedValue = priceFormatter.string(from: NSNumber(value: value)) else {
            return ""
        }
        return "\(formattedValue) kr"
    }
}

public final class TJTPriceView: UIView {
    private lazy var tradeTypeLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
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

        priceStackView.addArrangedSubviews([priceLabel, shippingLabel])
        contentStackView.addArrangedSubview(priceStackView)

        contentStackView.addArrangedSubview(paymentLabel)

        update()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func update() {
        tradeTypeLabel.text = viewModel.tradeType
        priceLabel.text = viewModel.price
        shippingLabel.attributedText = viewModel.shippingText
        paymentLabel.attributedText = viewModel.paymentInfoText(logoAlignedWithFont: paymentLabel.font)
    }
}
