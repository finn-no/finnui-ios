//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

public class ExploreCollectionViewModel: UniqueHashableItem, TagCloudLayoutDataProvider {
    public let title: String
    public let imageUrl: String?
    public let iconUrl: String?
    public var banner: BrazePromotionView? = nil

    // MARK: - Init

    public init(title: String, imageUrl: String? = nil, iconUrl: String? = nil, banner: BrazePromotionView? = nil) {
        self.title = title
        self.imageUrl = imageUrl
        self.iconUrl = iconUrl
        self.banner = banner
    }
}
