//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public struct ExploreDetailViewModel: Hashable {
    public let title: String
    public let subtitle: String
    public let imageUrl: String?
    public var sections: [Section]

    // MARK: - Init

    public init(
        title: String,
        subtitle: String,
        imageUrl: String?,
        sections: [ExploreDetailViewModel.Section]
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
        self.sections = sections
    }
}

// MARK: - Section

extension ExploreDetailViewModel {
    public struct Section: Hashable {
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
}
