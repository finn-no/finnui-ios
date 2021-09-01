//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public struct ExploreAdCellViewModel: Hashable {
    public let imageUrl: String?
    public let title: String?
    public let location: String?
    public let price: String?
    public let time: String?
    public let aspectRatio: CGFloat?
    public var isFavorite: Bool = false

    // MARK: - Init

    public init(
        imageUrl: String? = nil,
        title: String?,
        location: String?,
        price: String?,
        time: String?,
        aspectRatio: CGFloat?,
        isFavorite: Bool = false
    ) {
        self.imageUrl = imageUrl
        self.title = title
        self.location = location
        self.price = price
        self.time = time
        self.aspectRatio = aspectRatio
        self.isFavorite = isFavorite
    }
}
