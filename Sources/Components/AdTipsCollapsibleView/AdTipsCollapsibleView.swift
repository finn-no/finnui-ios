import UIKit
import FinniversKit

public protocol AdTipsCollapsibleViewDelegate: AnyObject {
    func adTipsCollapsibleView(_ view: AdTipsCollapsibleView, withIdentifier identifier: String, didChangeExpandState isExpanded: Bool)
}

public class AdTipsCollapsibleView: UIView {
    public typealias ButtonTitles = (expanded: String, collapsed: String)

    public private(set) var isExpanded: Bool = false

    // MARK: - Private properties

    private weak var delegate: AdTipsCollapsibleViewDelegate?
    private let identifier: String
    private let imageSize: CGSize
    private var expandCollapseButtonTitles: ButtonTitles?
    private var contentView: UIView?
    private lazy var headerStackView = UIStackView(axis: .horizontal, spacing: .spacingS, withAutoLayout: true)
    private lazy var footerView = UIView(withAutoLayout: true)
    private lazy var contentContainerView = UIView(withAutoLayout: true)
    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var headerImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var expandButton: Button = {
        let margins = UIEdgeInsets(top: .spacingS, left: .zero, bottom: .spacingS, right: .spacingM)
        let style = Button.Style.flat.overrideStyle(margins: margins)
        let button = Button(style: style, size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleExpandButtonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    public init(
        identifier: String,
        imageSize: CGSize = CGSize(width: 48, height: 48),
        delegate: AdTipsCollapsibleViewDelegate,
        withAutoLayout: Bool = false
    ) {
        self.identifier = identifier
        self.imageSize = imageSize
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        clipsToBounds = true
        contentContainerView.clipsToBounds = true

        backgroundColor = .bgSecondary
        layer.cornerRadius = .spacingS

        headerStackView.addArrangedSubviews([titleLabel, headerImageView])

        footerView.addSubview(expandButton)

        stackView.addArrangedSubviews([headerStackView, contentContainerView, footerView])
        contentContainerView.isHidden = !isExpanded
        addSubview(stackView)
        stackView.fillInSuperview(margin: .spacingS)

        NSLayoutConstraint.activate([
            headerImageView.heightAnchor.constraint(lessThanOrEqualToConstant: imageSize.height),
            headerImageView.widthAnchor.constraint(lessThanOrEqualToConstant: imageSize.width),

            expandButton.topAnchor.constraint(equalTo: footerView.topAnchor),
            expandButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            expandButton.trailingAnchor.constraint(lessThanOrEqualTo: footerView.trailingAnchor),
            expandButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor),
        ])
    }

    // MARK: - Public methods

    public func configure(
        with title: String,
        expandCollapseButtonTitles: ButtonTitles,
        headerImage: UIImage?,
        contentView: UIView
    ) {
        titleLabel.text = title
        self.expandCollapseButtonTitles = expandCollapseButtonTitles
        expandButton.setTitle(isExpanded ? expandCollapseButtonTitles.expanded : expandCollapseButtonTitles.collapsed, for: .normal)

        headerImageView.image = headerImage
        headerImageView.isHidden = headerImage == nil

        addContentView(contentView)
    }

    // MARK: - Private methods

    private func addContentView(_ newContentView: UIView) {
        contentView?.removeFromSuperview()
        contentView = newContentView

        contentContainerView.addSubview(newContentView)
        let bottomAnchor = newContentView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor)
        bottomAnchor.priority = .defaultLow

        NSLayoutConstraint.activate([
            newContentView.topAnchor.constraint(equalTo: contentContainerView.topAnchor),
            newContentView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
            newContentView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor),
            bottomAnchor,
        ])
    }

    // MARK: - Actions

    @objc private func handleExpandButtonTap() {
        isExpanded.toggle()
        expandButton.setTitle(isExpanded ? expandCollapseButtonTitles?.expanded : expandCollapseButtonTitles?.collapsed, for: .normal)

        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in
                guard let self = self else { return }
                self.contentContainerView.isHidden = !self.isExpanded
                self.contentContainerView.alpha = self.isExpanded ? 1 : 0
                self.stackView.layoutIfNeeded()
            }
        )

        delegate?.adTipsCollapsibleView(self, withIdentifier: identifier, didChangeExpandState: isExpanded)
    }
}
