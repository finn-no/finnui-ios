//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public struct ExploreDetailViewModel: Hashable {
    public let title: String
    public let subtitle: String
    public let imageUrl: String?

    // MARK: - Init

    public init(
        title: String,
        subtitle: String,
        imageUrl: String?
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
    }
}

// MARK: - Section

public class ExploreDetailSection: UniqueHashableItem {
    public enum Items: Hashable {
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
