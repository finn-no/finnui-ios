//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI

final class ExploreSectionHeaderView: UICollectionReusableView {
    private lazy var label: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.textColor = .textPrimary
        label.font = .title3Strong
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

    override func prepareForReuse() {
        label.text = nil
    }

    // MARK: - Setup

    func configure(withText text: String, font: UIFont = .title3Strong) {
        label.text = text
        label.font = font
    }

    private func setup() {
        addSubview(label)

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 6),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
