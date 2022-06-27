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

    public struct Payment {
        public let text: NSAttributedString
        public let accessibilityText: String

        public init(
            text: NSAttributedString,
            accessibilityText: String
        ) {
            self.text = text
            self.accessibilityText = accessibilityText
        }
    }

    public let tradeType: String
    public let price: String
    public let shipping: Shipping
    public let payment: Payment

    public init(
        tradeType: String,
        price: String,
        shipping: Shipping,
        payment: Payment
    ) {
        self.tradeType = tradeType
        self.price = price
        self.shipping = shipping
        self.payment = payment
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
        if let originalPriceText = shipping.originalPriceAccessibilityText {
            text += " \(originalPriceText)"
        }
        return text
    }
}
