//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class ExploreCollectionViewModel: UniqueHashableItem, TagCloudLayoutDataProvider {
    public let title: String
    public let imageUrl: String?
    public let iconUrl: String?

    // MARK: - Init

    public init(title: String, imageUrl: String? = nil, iconUrl: String? = nil) {
        self.title = title
        self.imageUrl = imageUrl
        self.iconUrl = iconUrl
    }
}
