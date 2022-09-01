import Foundation
import UIKit

public struct SearchLandingGroupItem: Hashable {
    public let title: NSAttributedString
    public let subtitle: String?
    public let imageUrl: String?
    public let titleColor: UIColor?
    //public let showDeleteButton: Bool

    public init(
        title: NSAttributedString,
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
