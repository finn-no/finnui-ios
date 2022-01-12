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

public class TagCloudCellViewModel: UniqueHashableItem, TagCloudLayoutDataProvider {
    public let title: String
    public let iconUrl: String?
    public let backgroundColor: UIColor
    public let foregroundColor: UIColor
    public let showShadow: Bool

    // MARK: - Init

    public init(
        title: String,
        iconUrl: String? = nil,
        backgroundColor: UIColor = .dynamicColor(defaultColor: UIColor(hex: "F3F4F6"), darkModeColor: .darkIce),
        foregroundColor: UIColor = .textPrimary,
        showShadow: Bool = false
    ) {
        self.title = title
        self.iconUrl = iconUrl
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.showShadow = showShadow
    }
}
