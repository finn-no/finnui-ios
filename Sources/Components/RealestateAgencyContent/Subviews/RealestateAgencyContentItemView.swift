import UIKit
import FinniversKit

protocol RealestateAgencyContentItemViewDelegate: AnyObject {
    func realestateAgencyContentItemViewDidSelectActionButton(_ view: RealestateAgencyContentItemView)
}

class RealestateAgencyContentItemView: UIView {
    enum ImageHeight {
        case constant(CGFloat)
        case widthMultiplier(multiplier: CGFloat = 9/16)
    }

    // MARK: - Internal properties

    weak var delegate: RealestateAgencyContentItemViewDelegate?

    // MARK: - Private properties

    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
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
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()

    // MARK: - Init

    init(
        article: RealestateAgencyContentViewModel.ArticleItem,
        imageHeight: ImageHeight,
        remoteImageViewDataSource: RemoteImageViewDataSource,
        delegate: RealestateAgencyContentItemViewDelegate?
    ) {
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        setup(imageHeight: imageHeight)
        configure(with: article, remoteImageViewDataSource: remoteImageViewDataSource)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup(imageHeight: ImageHeight) {
        stackView.addArrangedSubviews([titleLabel, imageView, bodyLabel])
        addSubview(stackView)
        stackView.fillInSuperview()

        switch imageHeight {
        case .constant(let heightConstant):
            imageView.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        case .widthMultiplier(let multiplier):
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: multiplier).isActive = true
        }
    }

    // MARK: - Private methods

    private func configure(
        with article: RealestateAgencyContentViewModel.ArticleItem,
        remoteImageViewDataSource: RemoteImageViewDataSource
    ) {
        titleLabel.text = article.title
        bodyLabel.text = article.body

        imageView.dataSource = remoteImageViewDataSource
        imageView.loadImage(for: article.imageUrl, imageWidth: .zero, loadingColor: .sardine)

        let actionButton = Button.create(for: article)
        stackView.addArrangedSubview(actionButton)
        actionButton.addTarget(self, action: #selector(handleActionButton), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func handleActionButton() {
        delegate?.realestateAgencyContentItemViewDidSelectActionButton(self)
    }
}

// MARK: - Private extensions

private extension Button {
    static func create(for article: RealestateAgencyContentViewModel.ArticleItem) -> Button {
        let button = Button(style: article.buttonKind.style, size: .normal, withAutoLayout: true)
        button.setTitle(article.buttonTitle, for: .normal)
        return button
    }
}

private extension RealestateAgencyContentViewModel.ArticleItem.ButtonKind {
    var style: Button.Style {
        switch self {
        case .highlighted:
            return .callToAction
        case .normal:
            return .flat
        }
    }
}
