//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

final class ExploreDetailSectionHeaderView: UICollectionReusableView {
    private lazy var label: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.textColor = .textPrimary
        return label
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

    func configure(withText text: String, font: UIFont) {
        label.font = font
        label.text = text
    }

    private func setup() {
        addSubview(label)

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 5),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM)
        ])
    }
}
