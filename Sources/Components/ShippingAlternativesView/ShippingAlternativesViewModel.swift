public struct ShippingAlternativesViewModel {
    let text: String
    let accessibilityLabel: String
    let link: String

    public init(
        text: String,
        accessibilityLabel: String,
        link: String
    ) {
        self.text = text
        self.accessibilityLabel = accessibilityLabel
        self.link = link
    }
}
