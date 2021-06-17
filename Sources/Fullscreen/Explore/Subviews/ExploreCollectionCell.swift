//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

final class ExploreCollectionCell: UICollectionViewCell {
    enum Kind {
        case regular
        case narrow
        case big
    }

    // MARK: - Internal properties

    weak var remoteImageViewDataSource: RemoteImageViewDataSource? {
        didSet {
            imageView.dataSource = remoteImageViewDataSource
        }
    }

    // MARK: - Private properties

    private lazy var imageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .accentSecondaryBlue
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .captionStrong
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.numberOfLines = 0
        label.dropShadow(color: .black, opacity: 0.5, offset: .zero, radius: 3)
        return label
    }()

    private lazy var titleBottomConstraint = titleLabel.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor,
        constant: -.spacingM
    )

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        imageView.cancelLoading()
        imageView.setImage(nil, animated: false)
        imageView.backgroundColor = .secondaryBlue
        titleLabel.text = nil
    }

    // MARK: - Setup

    func configure(with viewModel: ExploreCollectionViewModel, kind: Kind = .regular) {
        if let imageUrl = viewModel.imageUrl {
            imageView.loadImage(for: imageUrl, imageWidth: contentView.frame.size.width)
        }

        switch kind {
        case .regular, .narrow:
            titleLabel.font = .captionStrong
        case .big:
            titleLabel.font = .title3Strong
        }

        titleBottomConstraint.constant = kind == .narrow ? -.spacingS : -.spacingM

        titleLabel.text = viewModel.title
        titleLabel.sizeToFit()
    }

    private func setup() {
        clipsToBounds = true
        layer.cornerRadius = .spacingS

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)

        imageView.fillInSuperview()

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: .spacingM),
            titleBottomConstraint,
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM)
        ])
    }
}
