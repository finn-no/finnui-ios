import FinniversKit
import Foundation

public struct TJTPriceViewModel {
    public struct Shipping {
        public let text: String
        public let price: NSAttributedString
        public let priceAccessibilityText: String
        public let originalPrice: NSAttributedString?
        public let originalPriceAccessibilityText: String?

        public init(
            text: String,
            price: NSAttributedString,
            priceAccessibilityText: String,
            originalPrice: NSAttributedString?,
            originalPriceAccessibilityText: String?
        ) {
            self.text = text
            self.price = price
            self.priceAccessibilityText = priceAccessibilityText
            self.originalPrice = originalPrice
            self.originalPriceAccessibilityText = originalPriceAccessibilityText
        }
    }

    public let tradeType: String
    public let price: String
    public let shipping: Shipping
    public let paymentInfo: String

    public init(
        tradeType: String,
        price: String,
        shipping: Shipping,
        paymentInfo: String
    ) {
        self.tradeType = tradeType
        self.price = price
        self.shipping = shipping
        self.paymentInfo = paymentInfo
    }

    public var shippingText: NSAttributedString {
        let text = NSMutableAttributedString(string: "\(shipping.text) ")
        text.append(shipping.price)
        if let originalPrice = shipping.originalPrice {
            text.append(NSAttributedString(string: " "))
            text.append(originalPrice)
        }
        return text
    }

    public var shippingAccessibilityText: String {
        var text = "\(shipping.text) \(shipping.priceAccessibilityText)"
        if let originalPrice = shipping.originalPriceAccessibilityText {
            text += " \(originalPrice)"
        }
        return text
    }

    public func paymentInfoText(logoAlignedWithFont font: UIFont) -> NSAttributedString {
        let text = NSMutableAttributedString(string: paymentInfo + " ")
        let logo = UIImage(named: .vippsLogo)
        let logoAspect = logo.size.width / logo.size.height
        let logoAttachment = NSTextAttachment(image: logo)
        let logoHeight = font.xHeight - font.descender // Descender is negative when below baseline
        var logoBounds = logoAttachment.bounds
        logoBounds.origin.y = font.descender + 0.5 // Logo baseline is slightly off due to different font
        logoBounds.size = CGSize(width: logoHeight * logoAspect, height: logoHeight)
        logoAttachment.bounds = logoBounds
        text.append(NSAttributedString(attachment: logoAttachment))
        return text
    }

    public var paymentInfoAccessibilityText: String {
        return paymentInfo + " Vipps"
    }
}
