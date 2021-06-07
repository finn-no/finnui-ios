//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public struct ExploreSectionViewModel: Hashable {
    public enum Layout {
        case tagCloud
        case random
    }

    public let layout: Layout
    public let title: String
    public let items: [ExploreCollectionViewModel]

    // MARK: - Init

    public init(layout: Layout, title: String, items: [ExploreCollectionViewModel]) {
        self.layout = layout
        self.title = title
        self.items = items
    }
}
