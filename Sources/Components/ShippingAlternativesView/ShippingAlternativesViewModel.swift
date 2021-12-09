public struct ShippingAlternativesViewModel {
    let text: String
    let accessibilityLabel: String

    public init(
        text: String,
        accessibilityLabel: String
    ) {
        self.text = text
        self.accessibilityLabel = accessibilityLabel
    }
}
