import Foundation

public struct StoryViewModel {
    public let slides: [StorySlideViewModel]
    public let title: String?
    public let iconImageUrl: String?
    public let openAdButtonTitle: String?

    public init(
        slides: [StorySlideViewModel],
        title: String?,
        iconImageUrl: String?,
        openAdButtonTitle: String?
    ) {
        self.slides = slides
        self.title = title
        self.iconImageUrl = iconImageUrl
        self.openAdButtonTitle = openAdButtonTitle
    }
}
