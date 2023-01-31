//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

public class RecommendationsViewModel: UniqueHashableItem {
    public let title: String
    public let items: [ExploreRecommendationAdViewModel]

    // MARK: - Init

    public init(title: String, items: [ExploreRecommendationAdViewModel]) {
        self.title = title
        self.items = items
    }
}
