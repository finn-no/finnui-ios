import UIKit
import FinniversKit

protocol SearchDropdownGroupItemViewDelegate: AnyObject {
    func searchDropdownGroupItemViewWasSelected(_ view: SearchDropdownGroupItemView)
    func searchDropdownGroupItemViewDidSelectRemoveButton(_ view: SearchDropdownGroupItemView)
}

class SearchDropdownGroupItemView: UIView {

    // MARK: - Private properties

    private let item: SearchDropdownGroupItem?
    private weak var delegate: SearchDropdownGroupItemViewDelegate?
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
        item: SearchDropdownGroupItem,
        delegate: SearchDropdownGroupItemViewDelegate,
        remoteImageViewDataSource: RemoteImageViewDataSource,
        withAutoLayout: Bool = false
    ) {
        self.item = item
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout

        remoteImageView.dataSource = remoteImageViewDataSource
        remoteImageView.loadImage(for: item.imageUrl, imageWidth: imageAndButtonWidth)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    override init(frame: CGRect) {
        self.item = .init(title: "test", subtitle: nil, imageUrl: "https://images.finncdn.no/mmo/2022/7/vertical-0/14/0/265/322/740_158853377.jpg", showDeleteButton: false)
        super.init(frame: frame)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        titleLabel.text = item?.title
        titleLabel.textColor = item?.titleColor
        subtitleLabel.text = item?.subtitle
        removeButton.isHidden = !(item?.showDeleteButton ?? false)

        addSubview(contentStackView)
        contentStackView.fillInSuperview()

        contentStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleViewSelection)))

        NSLayoutConstraint.activate([
            remoteImageView.heightAnchor.constraint(equalToConstant: imageAndButtonWidth),
            remoteImageView.widthAnchor.constraint(equalToConstant: imageAndButtonWidth),

            removeButton.heightAnchor.constraint(equalToConstant: imageAndButtonWidth),
            removeButton.widthAnchor.constraint(equalToConstant: imageAndButtonWidth)
        ])

        layer.insertSublayer(highlightLayer, at: 0)
    }

    public func configure(with item: SearchLandingGroupItem, remoteImageViewDataSource: RemoteImageViewDataSource) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        guard let imageUrl = item.imageUrl else {
            // configure without image - set different constraints
            return
        }
        remoteImageView.dataSource = remoteImageViewDataSource
        remoteImageView.loadImage(for: imageUrl, imageWidth: imageAndButtonWidth)
        print("🕵️‍♀️", remoteImageView.delegate)
    }

    // MARK: - Actions

    @objc private func handleViewSelection() {
        delegate?.searchDropdownGroupItemViewWasSelected(self)
    }

    @objc private func handleRemoveButtonTap() {
        delegate?.searchDropdownGroupItemViewDidSelectRemoveButton(self)
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        highlightLayer.frame = bounds.insetBy(dx: -.spacingXS, dy: -.spacingXS)
        setHighlightColor(.bgPrimary)
    }
}

// MARK: - Touch / highlight handling.
extension SearchDropdownGroupItemView {
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

