import Foundation

public struct StorySlideViewModel {
    public let imageUrl: String?
    public let title: String?
    public let detailText: String?
    public let price: String?

    public init(
        imageUrl: String?,
        title: String?,
        detailText: String?,
        price: String?
    ) {
        self.imageUrl = imageUrl
        self.title = title
        self.detailText = detailText
        self.price = price
    }
}
