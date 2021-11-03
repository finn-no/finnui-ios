import Foundation

public struct StoryViewModel {
    public let slides: [StorySlideViewModel]
    public let title: String?
    public let iconImageUrl: String?

    init(
        slides: [StorySlideViewModel],
        title: String?,
        iconImageUrl: String?
    ) {
        self.slides = slides
        self.title = title
        self.iconImageUrl = iconImageUrl
    }
}
