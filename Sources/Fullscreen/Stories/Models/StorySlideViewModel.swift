import Foundation

public struct StorySlideViewModel {
    public let imageUrl: String?
    public let title: String?
    public let detailText: String?
    public let price: String?
    public let read: Bool?
    public let notificationId: Int?
    public let adId: Int?

    public init(
        imageUrl: String?,
        title: String?,
        detailText: String?,
        price: String?,
        read: Bool?,
        notificationId: Int? = nil,
        adId: Int? = nil
    ) {
        self.imageUrl = imageUrl
        self.title = title
        self.detailText = detailText
        self.price = price
        self.read = read
        self.notificationId = notificationId
        self.adId = adId
    }
}
