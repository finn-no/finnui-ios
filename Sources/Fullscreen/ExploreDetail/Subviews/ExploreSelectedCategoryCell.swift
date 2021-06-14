//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

final class ExploreSelectedCategoryCell: UICollectionViewCell {

    // MARK: - Internal properties

    weak var remoteImageViewDataSource: RemoteImageViewDataSource? {
        didSet {
            imageView.dataSource = remoteImageViewDataSource
        }
    }

    // MARK: - Private properties

    private static var iconSize: CGFloat = 30

    private lazy var imageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .textPrimary
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .detailStrong
        label.textColor = .textPrimary
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.numberOfLines = 0
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
        imageView.cancelLoading()
        imageView.setImage(nil, animated: false)
        titleLabel.text = nil
    }

    // MARK: - Setup

    func configure(with viewModel: ExploreCollectionViewModel) {
        if let iconUrl = viewModel.iconUrl {
            imageView.loadImage(for: iconUrl, imageWidth: ExploreSelectedCategoryCell.iconSize, modify: {
                $0?.withRenderingMode(.alwaysTemplate)
            })
        }

        titleLabel.text = viewModel.title
        titleLabel.sizeToFit()
    }

    private func setup() {
        clipsToBounds = true
        dropShadow(color: UIColor(hex: "C3CCD9"), opacity: 0.3, offset: CGSize(width: 0, height: 8), radius: 8)

        contentView.layer.cornerRadius = .spacingM
        contentView.backgroundColor = .dynamicColor(defaultColor: .bgPrimary, darkModeColor: .bgSecondary)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: ExploreSelectedCategoryCell.iconSize),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .spacingS),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingS),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingS)
        ])
    }
}
