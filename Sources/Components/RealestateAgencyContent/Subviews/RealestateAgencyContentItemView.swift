import UIKit
import FinniversKit

protocol RealestateAgencyContentItemViewDelegate: AnyObject {
    func realestateAgencyContentItemViewDidSelectActionButton(_ view: RealestateAgencyContentItemView)
}

class RealestateAgencyContentItemView: UIView {

    // MARK: - Internal properties

    weak var delegate: RealestateAgencyContentItemViewDelegate?

    // MARK: - Private properties

    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
    private var actionButton: Button?

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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        stackView.addArrangedSubviews([titleLabel, imageView, bodyLabel])
        addSubview(stackView)
        stackView.fillInSuperview()

        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 9/16).isActive = true
    }

    // MARK: - Internal methods

    func configure(
        with article: RealestateAgencyContentViewModel.ArticleItem,
        remoteImageViewDataSource: RemoteImageViewDataSource
    ) {
        titleLabel.text = article.title
        bodyLabel.text = article.body

        imageView.dataSource = remoteImageViewDataSource
        imageView.loadImage(for: article.imageUrl, imageWidth: .zero, loadingColor: .sardine)

        if let actionButton = actionButton {
            stackView.removeArrangedSubview(actionButton)
            self.actionButton = nil
        }

        let actionButton = Button.create(for: article)
        stackView.addArrangedSubview(actionButton)
        actionButton.addTarget(self, action: #selector(handleActionButton), for: .touchUpInside)
        self.actionButton = actionButton
    }

    // MARK: - Actions

    @objc private func handleActionButton() {
        delegate?.realestateAgencyContentItemViewDidSelectActionButton(self)
    }
}

// MARK: - Private extensions

extension Button {
    static func create(for article: RealestateAgencyContentViewModel.ArticleItem) -> Button {
        let button = Button(style: article.buttonKind.style, size: .normal, withAutoLayout: true)
        button.setTitle(article.buttonTitle, for: .normal)
        return button
    }
}

extension RealestateAgencyContentViewModel.ArticleItem.ButtonKind {
    var style: Button.Style {
        switch self {
        case .highlighted:
            return .callToAction
        case .normal:
            return .flat
        }
    }
}
