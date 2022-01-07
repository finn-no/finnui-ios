import UIKit
import FinniversKit

class RealestateAgencyHighlightedContentItemView: UIView {

    // MARK: - Internal properties

    weak var delegate: RealestateAgencyContentItemDelegate?

    // MARK: - Private properties

    private lazy var textStackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)
    private lazy var buttonStackView = UIStackView(axis: .horizontal, spacing: 0, withAutoLayout: true)

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: .spacingM, withAutoLayout: true)
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var bodyLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var imageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()

    // MARK: - Init

    init(
        article: RealestateAgencyContentViewModel.ArticleItem,
        styling: RealestateAgencyContentViewModel.Styling,
        remoteImageViewDataSource: RemoteImageViewDataSource,
        delegate: RealestateAgencyContentItemDelegate?
    ) {
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        setup()
        configure(with: article, styling: styling, remoteImageViewDataSource: remoteImageViewDataSource)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        textStackView.addArrangedSubviews([titleLabel, bodyLabel, buttonStackView])
        textStackView.setCustomSpacing(.spacingXL, after: bodyLabel)

        contentStackView.addArrangedSubviews([textStackView, imageView])
        addSubview(contentStackView)
        contentStackView.fillInSuperview()

        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1/2).isActive = true
    }

    // MARK: - Private methods

    private func configure(
        with article: RealestateAgencyContentViewModel.ArticleItem,
        styling: RealestateAgencyContentViewModel.Styling,
        remoteImageViewDataSource: RemoteImageViewDataSource
    ) {
        titleLabel.textColor = styling.textColor
        bodyLabel.textColor = styling.textColor

        titleLabel.text = article.title
        bodyLabel.text = article.body

        imageView.dataSource = remoteImageViewDataSource
        imageView.loadImage(for: article.imageUrl, imageWidth: .zero, loadingColor: .sardine)

        let actionButton = Button.create(for: article, styling: styling)
        actionButton.addTarget(self, action: #selector(handleActionButton), for: .touchUpInside)
        buttonStackView.addArrangedSubview(actionButton)

        if article.buttonKind == .normal {
            buttonStackView.addArrangedSubview(UIView(withAutoLayout: true))
        }
    }

    // MARK: - Actions

    @objc private func handleActionButton() {
        delegate?.realestateAgencyContentItemDidSelectActionButton(self)
    }
}
