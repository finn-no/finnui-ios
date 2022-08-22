import Foundation
import UIKit

public struct SearchLandingGroupItem: Hashable {
    public let title: String
    public let subtitle: String?
    public let imageUrl: String?
    public let titleColor: UIColor?
    //public let showDeleteButton: Bool

    public init(
        title: String,
        subtitle: String?,
        imageUrl: String?,
        titleColor: UIColor = .textPrimary
       // showDeleteButton: Bool
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
        self.titleColor = titleColor
        //self.showDeleteButton = showDeleteButton
    }
}
