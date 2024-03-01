//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

protocol ExploreAdCellDelegate: AnyObject {
    func exploreAdCell(_ cell: ExploreAdCell, didTapFavoriteButton button: UIButton)
}

final class ExploreAdCell: UICollectionViewCell {

    // MARK: - Internal properties

    weak var delegate: ExploreAdCellDelegate?

    weak var remoteImageViewDataSource: RemoteImageViewDataSource? {
        didSet {
            imageView.dataSource = remoteImageViewDataSource
        }
    }

    var isFavorite = false {
        didSet {
            favoriteButton.isToggled = isFavorite
        }
    }

    private(set) var viewModel: ExploreAdCellViewModel?
    private(set) var indexPath: IndexPath?

    // MARK: - Private properties

    private let imageView: RemoteImageView = {
        let view = RemoteImageView(withAutoLayout: true)
        view.backgroundColor = .accentSecondaryBlue
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        view.clipsToBounds = true
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = label(withFont: ExploreAdCell.titleFont, textColor: .textPrimary)
        label.numberOfLines = 2
        return label
    }()

    private lazy var locationLabel: UILabel = {
        let label = label(withFont: .detail, textColor: .textSecondary)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private lazy var timeLabel: UILabel = {
        let label = label(withFont: .detail, textColor: .textSecondary)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.textColor = .white
        label.font = .captionStrong
        label.numberOfLines = 1
        return label
    }()

    private lazy var priceBackground: UIView = {
        let view = UIView(withAutoLayout: true)
        view.clipsToBounds = true

        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
        effectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(effectView)
        effectView.fillInSuperview()

        let overlay1 = UIView(withAutoLayout: true)
        overlay1.backgroundColor = .black
        overlay1.layer.compositingFilter = "overlayBlendMode"
        view.addSubview(overlay1)
        overlay1.fillInSuperview()

        let overlay2 = UIView(withAutoLayout: true)
        overlay2.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        overlay2.layer.compositingFilter = "multiplyBlendMode"
        view.addSubview(overlay2)
        overlay2.fillInSuperview()

        return view
    }()

    private lazy var favoriteButton: IconButton = {
        let button = IconButton(style: .favorite)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleFavoriteButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var locationAndTimeStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [locationLabel, timeLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillProportionally
        view.axis = .horizontal
        view.spacing = .spacingM
        view.setContentHuggingPriority(.required, for: .vertical)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        return view
    }()

    private lazy var textStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [locationAndTimeStackView, titleLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = .spacingXS
        view.setContentHuggingPriority(.required, for: .vertical)
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        return view
    }()

    private var badgeView: BadgeView?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.layer.shadowPath = nil
        imageView.cancelLoading()
        imageView.setImage(nil, animated: false)
        imageView.backgroundColor = .accentSecondaryBlue
        titleLabel.text = nil
        locationLabel.text = nil
        timeLabel.text = nil
        priceLabel.text = nil
        badgeView?.removeFromSuperview()
        badgeView = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        priceBackground.layer.cornerRadius = priceBackground.frame.size.height / 2
    }

    // MARK: - Internal API

    func configure(with viewModel: ExploreAdCellViewModel, indexPath: IndexPath) {
        self.viewModel = viewModel
        self.indexPath = indexPath

        backgroundColor = .bgPrimary

        if let imageUrl = viewModel.imageUrl {
            imageView.loadImage(for: imageUrl, imageWidth: bounds.size.width)
        }

        titleLabel.text = viewModel.title
        locationLabel.text = viewModel.location
        timeLabel.text = viewModel.time
        priceLabel.text = viewModel.price
        priceLabel.sizeToFit()
        priceBackground.isHidden = viewModel.price == nil
        isFavorite = viewModel.isFavorite

        [titleLabel, locationLabel, timeLabel].forEach {
            $0.sizeToFit()
            $0.isHidden = $0.text == nil
        }

        if let badgeViewModel = viewModel.badgeViewModel {
            badgeView?.removeFromSuperview()
            badgeView = BadgeView()
            badgeView?.configure(with: badgeViewModel)
            badgeView?.attachToTopLeadingAnchor(in: imageView)
        }

        layoutIfNeeded()
    }

    // MARK: - Setup

    private func setup() {
        layer.backgroundColor = UIColor.bgPrimary.cgColor

        contentView.layer.masksToBounds = false
        contentView.addSubview(imageView)
        contentView.addSubview(textStackView)
        contentView.addSubview(favoriteButton)

        imageView.addSubview(priceBackground)
        imageView.addSubview(priceLabel)

        NSLayoutConstraint.activate([
            textStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.spacingS),
            textStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: textStackView.topAnchor, constant: -.spacingXS),

            priceBackground.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: .spacingS),
            priceBackground.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -.spacingS),
            priceBackground.heightAnchor.constraint(equalTo: priceLabel.heightAnchor, multiplier: 2),
            priceBackground.widthAnchor.constraint(equalTo: priceLabel.widthAnchor, constant: .spacingS * 2),

            priceLabel.centerYAnchor.constraint(equalTo: priceBackground.centerYAnchor),
            priceLabel.centerXAnchor.constraint(equalTo: priceBackground.centerXAnchor),

            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingS),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingS)
        ])
    }

    private func label(withFont font: UIFont, textColor: UIColor) -> UILabel {
        let label = UILabel(frame: .zero)
        label.backgroundColor = .bgPrimary
        label.textColor = textColor
        label.font = font
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }

    // MARK: - Actions

    @objc private func handleFavoriteButtonTap() {
        delegate?.exploreAdCell(self, didTapFavoriteButton: favoriteButton)
    }
}

// MARK: - Static

extension ExploreAdCell {
    private static let titleFont = UIFont.body

    static func textBlockHeight(for viewModel: ExploreAdCellViewModel, width: CGFloat) -> CGFloat {
        var height: CGFloat = .spacingXS

        height += viewModel.title?.height(withConstrainedWidth: width, font: titleFont) ?? 0

        if viewModel.location != nil || viewModel.time != nil {
            height += .spacingXS
            height += .spacingM
        }

        height += .spacingS

        return height
    }
}
