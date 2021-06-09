//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public struct ExploreCollectionViewModel: Hashable, TagCloudLayoutDataProvider {
    public let title: String
    public let imageUrl: String?
    public let iconUrl: String?

    // MARK: - Init

    public init(title: String, imageUrl: String?, iconUrl: String?) {
        self.title = title
        self.imageUrl = imageUrl
        self.iconUrl = iconUrl
    }
}
