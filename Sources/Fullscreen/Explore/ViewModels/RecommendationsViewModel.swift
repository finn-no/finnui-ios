//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

public class RecommendationsViewModel: UniqueHashableItem {
    public let title: String
    public let imageUrl: String?
    public let iconUrl: String?
    public let items: [ExploreRecommendationAdViewModel]

    // MARK: - Init

    public init(title: String, imageUrl: String? = nil, iconUrl: String? = nil, items: [ExploreRecommendationAdViewModel]) {
        self.title = title
        self.imageUrl = imageUrl
        self.iconUrl = iconUrl
        self.items = items
    }
}
