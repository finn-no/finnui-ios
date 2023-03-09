import UIKit
import FinniversKit

final public class FrontpageSearchImageResultCollectionViewCell: UICollectionViewCell {

    // MARK: - Private properties

    private let imageAndButtonWidth: CGFloat = 40
    private lazy var highlightLayer = CALayer()
    private let trailingIconSize: CGFloat = 14

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: .spacingM, withAutoLayout: true)
        stackView.alignment = .center
        stackView.addArrangedSubviews([remoteImageView, titlesStackView, removeButton, favoriteButton, trailingIconImageView])
        return stackView
    }()

    private lazy var remoteImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = .imageBorder
        imageView.layer.cornerRadius = .spacingS
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var titlesStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: 0, withAutoLayout: true)
        stackView.addArrangedSubviews([titleLabel, subtitleLabel])
        return stackView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.numberOfLines = 1
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.textColor = .textSecondary
        label.numberOfLines = 1
        return label
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .searchSmall)
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.tintColor = .textPrimary
        return imageView
    }()

    private lazy var removeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        let buttonImage = UIImage(named: .remove).withRenderingMode(.alwaysTemplate)
        button.setImage(buttonImage, for: .normal)
        button.imageView?.tintColor = .textPrimary
       // button.addTarget(self, action: #selector(handleRemoveButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        let favorited = UIImage(named: .favorited).withRenderingMode(.alwaysTemplate)
        button.setImage(favorited, for: .normal)
        button.imageView?.tintColor = .textAction
        button.imageEdgeInsets = UIEdgeInsets(vertical: 3 * .spacingXS, horizontal: 3 * .spacingXS)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var trailingIconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .externalLink)
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.tintColor = .textSecondary
        return imageView
    }()

    public weak var delegate: FrontpageSearchViewDelegate?
    private var currentItem: FrontpageSearchGroupItem?

    // MARK: - Init

    init(
        remoteImageViewDataSource: RemoteImageViewDataSource,
        withAutoLayout: Bool = false
    ) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        remoteImageView.dataSource = remoteImageViewDataSource
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(contentStackView)
        contentStackView.fillInSuperview()

        let layoutGuide = UILayoutGuide()
        addLayoutGuide(layoutGuide)

        addSubview(iconImageView)
        iconImageView.isHidden = true
        remoteImageView.isHidden = true
        removeButton.isHidden = true
        favoriteButton.isHidden = true
        trailingIconImageView.isHidden = true

        NSLayoutConstraint.activate([
            layoutGuide.topAnchor.constraint(equalTo: topAnchor),
            layoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            layoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            layoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM),

            remoteImageView.heightAnchor.constraint(equalToConstant: imageAndButtonWidth),
            remoteImageView.widthAnchor.constraint(equalToConstant: imageAndButtonWidth),
            remoteImageView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            remoteImageView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
            remoteImageView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),

            iconImageView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),

            removeButton.heightAnchor.constraint(equalToConstant: imageAndButtonWidth),
            removeButton.widthAnchor.constraint(equalToConstant: imageAndButtonWidth),
            removeButton.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),

            favoriteButton.heightAnchor.constraint(equalToConstant: imageAndButtonWidth),
            favoriteButton.widthAnchor.constraint(equalToConstant: imageAndButtonWidth),
            favoriteButton.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),

            trailingIconImageView.heightAnchor.constraint(equalToConstant: trailingIconSize),
            trailingIconImageView.widthAnchor.constraint(equalToConstant: trailingIconSize),
            trailingIconImageView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor)
        ])

        layer.insertSublayer(highlightLayer, at: 0)
    }

    public func configure(with item: FrontpageSearchGroupItem, remoteImageViewDataSource: RemoteImageViewDataSource) {
        titleLabel.attributedText = item.title
        titleLabel.textColor = item.titleColor
        subtitleLabel.text = item.subtitle

        configureLeadingImage(with: item, remoteImageViewDataSource)
        configureTrailingIcon(for: item.displayType)
        updateFavoriteButton(isFavorite: item.isFavorite)
        currentItem = item
    }

    private func configureLeadingImage(with item: FrontpageSearchGroupItem, _ remoteImageViewDataSource: RemoteImageViewDataSource) {
        guard let imageUrl = item.imageUrl, !imageUrl.isEmpty else {
            contentStackView.insertArrangedSubview(iconImageView, at: 0)
            iconImageView.isHidden = false
            return
        }
        contentStackView.insertArrangedSubview(remoteImageView, at: 0)
        if !item.imageContentModeFill {
            remoteImageView.contentMode = .scaleAspectFit
        }
        remoteImageView.isHidden = false
        remoteImageView.dataSource = remoteImageViewDataSource
        remoteImageView.loadImage(for: imageUrl, imageWidth: imageAndButtonWidth)
    }

    private func configureTrailingIcon(for displayType: FrontpageSearchGroupItem.FrontpageResultItemType) {
        switch displayType {
        case .companyProfile:
            trailingIconImageView.isHidden = false
        case .myFindings:
            favoriteButton.isHidden = false
        default: return
        }
    }

    public func updateFavoriteButton(isFavorite: Bool?) {
        guard let isFavorite = isFavorite else { return }
        let favoriteImage = isFavorite ? UIImage(named: .favorited) : UIImage(named: .notFavorited).withRenderingMode(.alwaysTemplate)
        favoriteButton.setImage(favoriteImage, for: .normal)
    }

    public func getAdIdForCell() -> Int? {
        return currentItem?.adId
    }

    // MARK: - Actions

    @objc private func favoriteButtonTapped() {
        guard let id = currentItem?.adId else { return }
        delegate?.frontpageSearchView(didSelectFavoriteButton: self.favoriteButton, forAdWithId: id, cell: self)
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()
        highlightLayer.frame = bounds.insetBy(dx: -.spacingXS, dy: -.spacingXS)
    }

    // MARK: - Reuse

    public override func prepareForReuse() {
        super.prepareForReuse()
        clearLabelContent()
        clearLeadingImages()
        hideTrailingIcons()
        currentItem = nil
    }

    private func clearLabelContent() {
        titleLabel.attributedText = nil
        subtitleLabel.text = nil
        titleLabel.textColor = .textPrimary
    }

    private func clearLeadingImages() {
        iconImageView.isHidden = true
        remoteImageView.contentMode = .scaleAspectFill
        remoteImageView.isHidden = true
        contentStackView.removeArrangedSubview(iconImageView)
        contentStackView.removeArrangedSubview(remoteImageView)
    }

    private func hideTrailingIcons() {
        removeButton.isHidden = true
        favoriteButton.isHidden = true
        trailingIconImageView.isHidden = true
    }

}

