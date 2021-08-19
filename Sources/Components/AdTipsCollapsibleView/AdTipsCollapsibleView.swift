import UIKit
import FinniversKit

public class AdTipsCollapsibleView: UIView {
    public typealias ButtonTitles = (expanded: String, collapsed: String)

    public var isExpanded: Bool = false

    // MARK: - Private properties

    private var buttonTitles: ButtonTitles?
    private var contentView: UIView?
    private lazy var headerView = UIView(withAutoLayout: true)
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

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        clipsToBounds = true
        contentContainerView.clipsToBounds = true

        backgroundColor = .bgSecondary
        layer.cornerRadius = .spacingS

        headerView.addSubview(titleLabel)
        headerView.addSubview(headerImageView)

        footerView.addSubview(expandButton)

        stackView.addArrangedSubviews([headerView, contentContainerView, footerView])
        contentContainerView.isHidden = !isExpanded
        addSubview(stackView)
        stackView.fillInSuperview(margin: .spacingS)

        NSLayoutConstraint.activate([
            /// Header.
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),

            headerImageView.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: .spacingS),
            headerImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            headerImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: 48),
            headerImageView.widthAnchor.constraint(equalToConstant: 48),

            /// Footer.
            expandButton.topAnchor.constraint(equalTo: footerView.topAnchor),
            expandButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            expandButton.trailingAnchor.constraint(lessThanOrEqualTo: footerView.trailingAnchor),
            expandButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor),
        ])
    }

    // MARK: - Public methods

    public func configure(
        with title: String,
        buttonTitles: ButtonTitles,
        headerImage: UIImage?,
        contentView: UIView
    ) {
        titleLabel.text = title
        self.buttonTitles = buttonTitles
        expandButton.setTitle(buttonTitles.expanded, for: .normal)
        headerImageView.image = headerImage
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
        expandButton.setTitle(isExpanded ? buttonTitles?.expanded : buttonTitles?.collapsed, for: .normal)

        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in
                guard let self = self else { return }
                self.contentContainerView.isHidden = !self.isExpanded
                self.contentContainerView.alpha = self.isExpanded ? 1 : 0
                self.stackView.layoutIfNeeded()
            }
        )
    }
}
