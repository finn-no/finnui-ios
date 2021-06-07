//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public struct ExploreSectionViewModel: Hashable {
    public let title: String
    public let items: [ExploreCollectionViewModel]

    // MARK: - Init

    public init(title: String, items: [ExploreCollectionViewModel]) {
        self.title = title
        self.items = items
    }
}
