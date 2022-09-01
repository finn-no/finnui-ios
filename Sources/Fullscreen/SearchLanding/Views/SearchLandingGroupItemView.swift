import UIKit
import FinniversKit

protocol SearchLandingGroupItemViewDelegate: AnyObject {
    func SearchLandingGroupItemViewWasSelected(_ view: SearchLandingGroupItemView)
    func SearchLandingGroupItemViewDidSelectRemoveButton(_ view: SearchLandingGroupItemView)
}

class SearchLandingGroupItemView: UIView {

    // MARK: - Private properties

    private let item: SearchLandingGroupItem?
    private weak var delegate: SearchLandingGroupItemViewDelegate?
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
        label.numberOfLines = 0
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.textColor = .textSecondary
        label.numberOfLines = 0
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
        delegate: SearchLandingGroupItemViewDelegate,
        remoteImageViewDataSource: RemoteImageViewDataSource,
        withAutoLayout: Bool = false
    ) {
        self.item = item
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout

        remoteImageView.dataSource = remoteImageViewDataSource
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    override init(frame: CGRect) {
        let sharedAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.body, .foregroundColor: UIColor.textPrimary]
        let attributedString = NSMutableAttributedString(string: "test", attributes: sharedAttributes)
        self.item = .init(title: attributedString, subtitle: nil, imageUrl: "https://images.finncdn.no/mmo/2022/7/vertical-0/14/0/265/322/740_158853377.jpg")
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

        contentStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleViewSelection)))

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
            removeButton.widthAnchor.constraint(equalToConstant: imageAndButtonWidth)
        ])

        layer.insertSublayer(highlightLayer, at: 0)
    }

    public func configure(with item: SearchLandingGroupItem, remoteImageViewDataSource: RemoteImageViewDataSource) {
        titleLabel.attributedText = item.title
        subtitleLabel.text = item.subtitle
        guard let imageUrl = item.imageUrl else {
            print("🕵️‍♀️ imageurl was nil")
            contentStackView.insertArrangedSubview(iconImageView, at: 0)
            contentStackView.removeArrangedSubview(remoteImageView)
            iconImageView.isHidden = false
            remoteImageView.isHidden = true
            // configure without image - set different constraints
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

    @objc private func handleViewSelection() {
        delegate?.SearchLandingGroupItemViewWasSelected(self)
    }

    @objc private func handleRemoveButtonTap() {
        delegate?.SearchLandingGroupItemViewDidSelectRemoveButton(self)
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        highlightLayer.frame = bounds.insetBy(dx: -.spacingXS, dy: -.spacingXS)
        setHighlightColor(.bgPrimary)
    }
}

// MARK: - Touch / highlight handling.
extension SearchLandingGroupItemView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        setHighlightColor(.defaultCellSelectedBackgroundColor)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        setHighlightColor(.bgPrimary)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        setHighlightColor(.bgPrimary)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        if let touch = touches.first, bounds.contains(touch.location(in: self)) {
            setHighlightColor(.defaultCellSelectedBackgroundColor)
        } else {
            setHighlightColor(.bgPrimary)
        }
    }

    /// Disable implicit layer animation when changing highlight color.
    private func setHighlightColor(_ color: UIColor) {
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        highlightLayer.backgroundColor = color.cgColor
        CATransaction.commit()
    }
}

