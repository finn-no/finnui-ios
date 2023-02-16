import FinniversKit

public struct FiksFerdigPriceViewModel {
    public let tradeType: String
    public let priceText: PriceText
    public let shipping: Shipping
    public let payment: Payment

    public init(
        tradeType: String,
        priceText: PriceText,
        shipping: Shipping,
        payment: Payment
    ) {
        self.tradeType = tradeType
        self.priceText = priceText
        self.shipping = shipping
        self.payment = payment
    }

    var priceString: String {
        switch priceText {
        case .setPrice(let price),
             .noPrice(let price):
            return price
        }
    }
}

extension FiksFerdigPriceViewModel {
    public enum PriceText {
        case setPrice(String)
        case noPrice(String)
    }

    public struct Shipping {
        public let text: NSAttributedString
        public let darkModeText: NSAttributedString
        private let providedAccessibilityText: String?
        public var accessibilityText: String {
            return providedAccessibilityText ?? text.string
        }

        public init(
            text: NSAttributedString,
            darkModeText: NSAttributedString,
            accessibilityText: String?
        ) {
            self.text = text
            self.darkModeText = darkModeText
            self.providedAccessibilityText = accessibilityText
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
