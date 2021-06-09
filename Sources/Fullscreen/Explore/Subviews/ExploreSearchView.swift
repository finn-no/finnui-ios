//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI

final class ExploreSearchView: UIView {
    private lazy var filterButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    func configure(withText text: String) {
    }

    private func setup() {
        addSubview(filterButton)

        NSLayoutConstraint.activate([
            filterButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 6),
            filterButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            filterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
        ])
    }
}
