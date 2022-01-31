//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public struct ExploreDetailViewModel: Hashable {
    public let title: String
    public let subtitle: String
    public let imageUrl: String?
    public let showHeroView: Bool

    // MARK: - Init

    public init(
        title: String,
        subtitle: String,
        imageUrl: String?,
        showHeroView: Bool
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
        self.showHeroView = showHeroView
    }
}

// MARK: - Section

public class ExploreDetailSection: UniqueHashableItem {
    public enum Items: Hashable {
        case selectedCategories([ExploreCollectionViewModel])
        case collections([ExploreCollectionViewModel])
        case ads([ExploreAdCellViewModel])
    }

    public let title: String?
    public let items: Items

    public init(title: String?, items: Items) {
        self.title = title
        self.items = items
    }
}
