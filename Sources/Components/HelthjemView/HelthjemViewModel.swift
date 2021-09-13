public struct HelthjemViewModel {
    let title: String
    let detail: String
    let primaryButtonTitle: String
    let primaryButtonAccessibilityLabel: String
    let secondaryButtonTitle: String?
    let secondaryButtonAccessibilityLabel: String?
    let accessibilityLabel: String

    public init(
        title: String,
        detail: String,
        primaryButtonTitle: String,
        primaryButtonAccessibilityLabel: String,
        secondaryButtonTitle: String? = nil,
        secondaryButtonAccessibilityLabel: String? = nil,
        accessibilityLabel: String
    ) {
        self.title = title
        self.detail = detail
        self.primaryButtonTitle = primaryButtonTitle
        self.primaryButtonAccessibilityLabel = primaryButtonAccessibilityLabel
        self.secondaryButtonTitle = secondaryButtonTitle
        self.secondaryButtonAccessibilityLabel = secondaryButtonAccessibilityLabel
        self.accessibilityLabel = accessibilityLabel
    }
}
