//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

// MARK: - Layout data

public protocol TagCloudLayoutDataProvider {
    var title: String { get }
    var iconUrl: String? { get }
}

// MARK: - View Model

public struct TagCloudCellViewModel: Hashable, TagCloudLayoutDataProvider {
    public let title: String
    public let iconUrl: String?
    public let backgroundColor: UIColor
    public let foregroundColor: UIColor
    public let showShadow: Bool

    // MARK: - Init

    public init(
        title: String,
        iconUrl: String?,
        backgroundColor: UIColor = UIColor(hex: "#F3F4F6"),
        foregroundColor: UIColor = .licorice,
        showShadow: Bool = true
    ) {
        self.title = title
        self.iconUrl = iconUrl
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.showShadow = showShadow
    }
}
