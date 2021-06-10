//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public struct TagCloudCellViewModel: Hashable {
    public let text: String
    public let iconUrl: String?
    public let backgroundColor: UIColor?
    public let foregroundColor: UIColor?
    public let showShadow: Bool

    // MARK: - Init

    public init(
        text: String,
        iconUrl: String?,
        backgroundColor: UIColor?,
        foregroundColor: UIColor?,
        showShadow: Bool = true
    ) {
        self.text = text
        self.iconUrl = iconUrl
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.showShadow = showShadow
    }
}
