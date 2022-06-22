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
    public let paymentInfo: String
    public let priceFormatter: NumberFormatter
    public let priceAccessibilityFormatter: NumberFormatter

    public init(
        tradeType: String,
        price: String,
        shipping: Shipping,
        paymentInfo: String,
        priceFormatter: NumberFormatter,
        priceAccessibilityFormatter: NumberFormatter
    ) {
        self.tradeType = tradeType
        self.price = price
        self.shipping = shipping
        self.paymentInfo = paymentInfo
        self.priceFormatter = priceFormatter
        self.priceAccessibilityFormatter = priceAccessibilityFormatter
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

    public var shippingAccessibilityText: String {
        let shippingPrice = formatCurrency(shipping.price, accessible: true)
        var text = "\(shipping.text) \(shippingPrice)"
        if let originalPrice = shipping.originalPrice {
            let originalPriceText = formatCurrency(originalPrice, accessible: true)
            text += ", original fraktpris \(originalPriceText)"
        }
        return text
    }

    public var paymentInfoAccessibilityText: String {
        return paymentInfo + " Vipps"
    }

    public func paymentInfoText(logoAlignedWithFont font: UIFont) -> NSAttributedString {
        let text = NSMutableAttributedString(string: paymentInfo + " ")
        let logo = UIImage(named: .vippsLogo)
        let logoAspect = logo.size.width / logo.size.height
        let logoAttachment = NSTextAttachment(image: logo)
        let lineAscentAndDescent = font.ascender + font.descender
        // Since we don't have a baseline for the logo we must calculate the correct alignment and
        // size based on the font of the text in front of the logo. The ascent and the descent added
        // together is the maximum logo height. The logo y position is set to the descender to align
        // with the baseline. The descender offset is necessary since the font in the logo is
        // different so the alignment is slightly off, and was found with measurement using 12 pt
        // font as reference.
        let descenderOffset = font.pointSize / 12
        var logoBounds = logoAttachment.bounds
        logoBounds.origin.y = font.descender + descenderOffset
        logoBounds.size = CGSize(width: lineAscentAndDescent * logoAspect, height: lineAscentAndDescent)
        logoAttachment.bounds = logoBounds
        text.append(NSAttributedString(attachment: logoAttachment))
        return text
    }

    private func formatCurrency(_ value: Double, accessible: Bool = false) -> String {
        let formatter = accessible ? priceAccessibilityFormatter : priceFormatter
        guard let formattedValue = formatter.string(from: NSNumber(value: value)) else {
            return ""
        }
        return "\(formattedValue) \(accessible ? "kroner" : "kr")"
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

        priceStackView.addArrangedSubviews([priceLabel, shippingLabel])
        contentStackView.addArrangedSubview(priceStackView)

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