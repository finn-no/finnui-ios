import Foundation
import UIKit

public struct FrontpageSearchGroupItem: Hashable {
    public let title: NSAttributedString
    public let subtitle: String?
    public let detail: String?
    public let imageUrl: String?
    public let titleColor: UIColor?
    public let uuid: UUID
    public let groupType: ResultGroupType
    public let displayType: FrontpageResultItemType
    public let adId: Int?
    public let isFavorite: Bool?
    public let imageContentModeFill: Bool?

    public enum ResultGroupType {
        case searchResult
        case locationPermission
        case showMoreResults
    }

    public enum FrontpageResultItemType {
        case companyProfile
        case geo
        case myFindings
        case myFindingsList
        case recommend
        case standard
    }

    public init(
        title: NSAttributedString,
        subtitle: String? = nil,
        detail: String? = nil,
        imageUrl: String?,
        titleColor: UIColor = .textPrimary,
        uuid: UUID,
        groupType: ResultGroupType,
        displayType: FrontpageResultItemType,
        adId: Int? = nil,
        isFavorite: Bool? = nil,
        imageContentModeFill: Bool? = true
    ) {
        self.title = title
        self.subtitle = subtitle
        self.detail = detail
        self.imageUrl = imageUrl
        self.titleColor = titleColor
        self.uuid = uuid
        self.groupType = groupType
        self.displayType = displayType
        self.adId = adId
        self.isFavorite = isFavorite
        self.imageContentModeFill = imageContentModeFill
    }
}
