import Foundation
import UIKit

public struct SearchLandingGroupItem: Hashable {
    public let title: NSAttributedString
    public let subtitle: String?
    public let detail: String?
    public let imageUrl: String?
    public let titleColor: UIColor?
    public let uuid: UUID
    public let type: SearchResultType
    //public let showDeleteButton: Bool

    public enum SearchResultType {
        case searchResult
        case locationPermission
        case showMoreResults
    }
    public init(
        title: NSAttributedString,
        subtitle: String? = nil,
        detail: String? = nil,
        imageUrl: String?,
        titleColor: UIColor = .textPrimary,
        uuid: UUID,
        type: SearchResultType
       // showDeleteButton: Bool
    ) {
        self.title = title
        self.subtitle = subtitle
        self.detail = detail
        self.imageUrl = imageUrl
        self.titleColor = titleColor
        self.uuid = uuid
        self.type = type
        //self.showDeleteButton = showDeleteButton
    }
}
