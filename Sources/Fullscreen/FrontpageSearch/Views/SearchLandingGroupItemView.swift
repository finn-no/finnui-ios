import UIKit
import FinniversKit


class SearchLandingGroupItemView: UIView {

    // MARK: - Private properties

    private lazy var titleLabel: UILabel = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private lazy var detailLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.textColor = .textPrimary
        label.font = .detail
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

    // MARK: - Init

    init(
        remoteImageViewDataSource: RemoteImageViewDataSource,
        withAutoLayout: Bool = false
    ) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgPrimary

        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(iconImageView)

        let layoutGuide = UILayoutGuide()
        addLayoutGuide(layoutGuide)

        NSLayoutConstraint.activate([
            layoutGuide.topAnchor.constraint(equalTo: topAnchor),
            layoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            layoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            layoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor),

            iconImageView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .spacingS),
            titleLabel.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),

            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: .spacingXS),
            detailLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor)
        ])
    }

    // MARK: - Configure

    func configure(with item: FrontpageSearchGroupItem) {
        titleLabel.attributedText = item.title
        titleLabel.textColor = item.titleColor
        detailLabel.text = item.detail
    }
}

    /*// MARK: - Private properties

    private let item: SearchLandingGroupItem?
    private let imageAndButtonWidth: CGFloat = 40
    private lazy var titlesStackViewTrailingConstraint = titlesStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM)
    private lazy var highlightLayer = CALayer()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: .spacingM, withAutoLayout: true)
        stackView.alignment = .center
        stackView.addArrangedSubviews([remoteImageView, titlesStackView, removeButton])
        return stackView
    }()

    private lazy var remoteImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
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
        let label = Label(style: .caption, withAutoLayout: true)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.textColor = .textSecondary
        label.numberOfLines = 1
        return label
    }()

    private lazy var detailLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.textColor = .textPrimary
        label.font = .detail
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
        button.addTarget(self, action: #selector(handleRemoveButtonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    init(
        item: SearchLandingGroupItem,
        remoteImageViewDataSource: RemoteImageViewDataSource,
        withAutoLayout: Bool = false
    ) {
        self.item = item
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout

        remoteImageView.dataSource = remoteImageViewDataSource
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    override init(frame: CGRect) {
        let sharedAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.body, .foregroundColor: UIColor.textPrimary]
        let attributedString = NSMutableAttributedString(string: "test", attributes: sharedAttributes)
        self.item = .init(title: attributedString, subtitle: nil, detail: nil, imageUrl: "https://images.finncdn.no/mmo/2022/7/vertical-0/14/0/265/322/740_158853377.jpg", uuid: UUID(), type: .searchResult)
        super.init(frame: frame)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        titleLabel.attributedText = item?.title
        titleLabel.textColor = item?.titleColor
        subtitleLabel.text = item?.subtitle
        removeButton.isHidden = true

        addSubview(contentStackView)
        contentStackView.fillInSuperview()

        let layoutGuide = UILayoutGuide()
        addLayoutGuide(layoutGuide)

        addSubview(iconImageView)
        iconImageView.isHidden = true
        remoteImageView.isHidden = true

        addSubview(detailLabel)

        NSLayoutConstraint.activate([
            layoutGuide.topAnchor.constraint(equalTo: topAnchor, constant: .spacingS),
            layoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            layoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            layoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingS),

            remoteImageView.heightAnchor.constraint(equalToConstant: imageAndButtonWidth),
            remoteImageView.widthAnchor.constraint(equalToConstant: imageAndButtonWidth),
            remoteImageView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),

            iconImageView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),

            removeButton.heightAnchor.constraint(equalToConstant: imageAndButtonWidth),
            removeButton.widthAnchor.constraint(equalToConstant: imageAndButtonWidth),


            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: .spacingXS),
            detailLabel.lastBaselineAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor)
        ])

        layer.insertSublayer(highlightLayer, at: 0)
    }

    public func configure(with item: SearchLandingGroupItem, remoteImageViewDataSource: RemoteImageViewDataSource) {
        titleLabel.attributedText = item.title
        titleLabel.textColor = item.titleColor

        subtitleLabel.text = item.subtitle
        detailLabel.text = item.detail
        guard let imageUrl = item.imageUrl, !imageUrl.isEmpty else {
            print("🕵️‍♀️ imageurl was nil")
            contentStackView.insertArrangedSubview(iconImageView, at: 0)
            contentStackView.removeArrangedSubview(remoteImageView)
            iconImageView.isHidden = false
            remoteImageView.isHidden = true
            return
        }
        contentStackView.insertArrangedSubview(remoteImageView, at: 0)
        contentStackView.removeArrangedSubview(iconImageView)
        iconImageView.isHidden = true
        remoteImageView.isHidden = false
        remoteImageView.dataSource = remoteImageViewDataSource
        remoteImageView.loadImage(for: imageUrl, imageWidth: imageAndButtonWidth)
    }

    // MARK: - Actions

    @objc private func handleRemoveButtonTap() {
        print("Tapped", #function)
        //delegate?.SearchLandingGroupItemViewDidSelectRemoveButton(self)
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        highlightLayer.frame = bounds.insetBy(dx: -.spacingXS, dy: -.spacingXS)
    }
}
*/
