//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

public class ExploreAdCellViewModel: UniqueHashableItem {
    public let imageUrl: String?
    public let title: String?
    public let location: String?
    public let price: String?
    public let time: String?
    public let aspectRatio: CGFloat?
    public let badgeViewModel: BadgeViewModel?
    public var isFavorite: Bool = false

    // MARK: - Init

    public init(
        imageUrl: String? = nil,
        title: String?,
        location: String?,
        price: String?,
        time: String?,
        aspectRatio: CGFloat?,
        badgeViewModel: BadgeViewModel? = nil,
        isFavorite: Bool = false
    ) {
        self.imageUrl = imageUrl
        self.title = title
        self.location = location
        self.price = price
        self.time = time
        self.aspectRatio = aspectRatio
        self.badgeViewModel = badgeViewModel
        self.isFavorite = isFavorite
    }
}
