//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public struct ExploreViewModel {
    public let filterIcon: UIImage
    public let filterButtonTitle: String
    public let searchIcon: UIImage
    public let searchPlaceholderText: String

    // MARK: - Init

    public init(
        filterIcon: UIImage,
        filterButtonTitle: String,
        searchIcon: UIImage,
        searchPlaceholderText: String
    ) {
        self.filterIcon = filterIcon
        self.filterButtonTitle = filterButtonTitle
        self.searchIcon = searchIcon
        self.searchPlaceholderText = searchPlaceholderText
    }
}
