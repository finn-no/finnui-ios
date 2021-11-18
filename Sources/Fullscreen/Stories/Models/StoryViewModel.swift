import Foundation

public struct StoryViewModel {
    public let title: String?
    public let iconImageUrl: String?
    public let openAdButtonTitle: String?

    public init(
        title: String?,
        iconImageUrl: String?,
        openAdButtonTitle: String?
    ) {
        self.title = title
        self.iconImageUrl = iconImageUrl
        self.openAdButtonTitle = openAdButtonTitle
    }
}
