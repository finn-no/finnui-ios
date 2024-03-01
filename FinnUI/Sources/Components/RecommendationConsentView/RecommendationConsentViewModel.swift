import UIKit

public struct RecommendationConsentViewModel {
    public let titleText: String
    public let detailText: String
    public let buttonText: String
    public let icon: UIImage?

    public init(titleText: String, detailText: String, buttonText: String, icon: UIImage? = nil) {
        self.titleText = titleText
        self.detailText = detailText
        self.buttonText = buttonText
        self.icon = icon
    }
}
