import UIKit

public struct RecommendationEmptyViewModel {
    public let titleText: String
    public let detailText: String
    public let icon: UIImage?

    public init(titleText: String, detailText: String, icon: UIImage? = nil) {
        self.titleText = titleText
        self.detailText = detailText
        self.icon = icon
    }
}
