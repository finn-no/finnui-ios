import FinniversKit

public struct TJTPriceViewModel {
    public let tradeType: String
    public let priceText: String
    public let shipping: Shipping
    public let payment: Payment

    public init(
        tradeType: String,
        priceText: String,
        shipping: Shipping,
        payment: Payment
    ) {
        self.tradeType = tradeType
        self.priceText = priceText
        self.shipping = shipping
        self.payment = payment
    }
}

extension TJTPriceViewModel {
    public struct Shipping {
        public let text: String
        public let accessibilityText: String?

        public init(
            text: String,
            accessibilityText: String?
        ) {
            self.text = text
            self.accessibilityText = accessibilityText
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
}
