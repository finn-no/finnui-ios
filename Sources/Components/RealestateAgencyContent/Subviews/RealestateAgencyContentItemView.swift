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

    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)
    private lazy var buttonStackView = UIStackView(axis: .horizontal, spacing: 0, withAutoLayout: true)

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
        colors: RealestateAgencyContentViewModel.Colors,
        imageHeight: ImageHeight,
        remoteImageViewDataSource: RemoteImageViewDataSource,
        delegate: RealestateAgencyContentItemViewDelegate?
    ) {
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        setup(imageHeight: imageHeight)
        configure(with: article, colors: colors, remoteImageViewDataSource: remoteImageViewDataSource)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup(imageHeight: ImageHeight) {
        stackView.addArrangedSubviews([titleLabel, imageView, bodyLabel, buttonStackView])
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
        colors: RealestateAgencyContentViewModel.Colors,
        remoteImageViewDataSource: RemoteImageViewDataSource
    ) {
        titleLabel.textColor = colors.main.text
        bodyLabel.textColor = colors.main.text

        titleLabel.text = article.title
        bodyLabel.text = article.body

        imageView.dataSource = remoteImageViewDataSource
        imageView.loadImage(for: article.imageUrl, imageWidth: .zero, loadingColor: .sardine)

        let actionButton = Button.create(for: article, textColor: colors.actionButton.text, backgroundColor: colors.actionButton.background)
        buttonStackView.addArrangedSubviews([actionButton, UIView(withAutoLayout: true)])
        actionButton.addTarget(self, action: #selector(handleActionButton), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func handleActionButton() {
        delegate?.realestateAgencyContentItemViewDidSelectActionButton(self)
    }
}
