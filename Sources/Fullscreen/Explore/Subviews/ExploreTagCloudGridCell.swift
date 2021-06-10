//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

final class ExploreTagCloudGridCell: UICollectionViewCell {
    var section: Int?
    private(set) lazy var gridView = TagCloudGridView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        contentView.addSubview(gridView)
        gridView.fillInSuperview()
    }
}
