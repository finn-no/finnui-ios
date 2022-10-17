import UIKit
import FinniversKit

class RealestateAgencyContentItemView: UIView {
    enum ImageHeight {
        case constant(CGFloat)
        case widthMultiplier(multiplier: CGFloat = 9/16)
    }

    // MARK: - Internal properties

    weak var delegate: RealestateAgencyContentItemDelegate?

    // MARK: - Private properties

    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)
    private lazy var buttonStackView = UIStackView(axis: .horizontal, spacing: 0, withAutoLayout: true)

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
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()

    // MARK: - Init

    init(
        article: RealestateAgencyContentViewModel.ArticleItem,
<<<<<<< HEAD
        styling: RealestateAgencyContentViewModel.Styling,
=======
        style: CompanyProfile.ProfileStyle,
>>>>>>> master
        imageHeight: ImageHeight,
        remoteImageViewDataSource: RemoteImageViewDataSource,
        delegate: RealestateAgencyContentItemDelegate?
    ) {
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        setup(imageHeight: imageHeight)
<<<<<<< HEAD
        configure(with: article, styling: styling, remoteImageViewDataSource: remoteImageViewDataSource)
=======
        configure(with: article, style: style, remoteImageViewDataSource: remoteImageViewDataSource)
>>>>>>> master
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup(imageHeight: ImageHeight) {
        stackView.addArrangedSubviews([imageView, titleLabel, bodyLabel, buttonStackView])
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
<<<<<<< HEAD
        styling: RealestateAgencyContentViewModel.Styling,
        remoteImageViewDataSource: RemoteImageViewDataSource
    ) {
        titleLabel.textColor = styling.textColor
        bodyLabel.textColor = styling.textColor
=======
        style: CompanyProfile.ProfileStyle,
        remoteImageViewDataSource: RemoteImageViewDataSource
    ) {
        titleLabel.textColor = style.textColor
        bodyLabel.textColor = style.textColor
>>>>>>> master

        titleLabel.text = article.title
        bodyLabel.text = article.body

        imageView.dataSource = remoteImageViewDataSource
        imageView.loadImage(for: article.imageUrl, imageWidth: .zero, loadingColor: .sardine)

<<<<<<< HEAD
        let actionButton = Button.create(for: article, styling: styling)
=======
        let actionButton = Button.create(for: article, profileStyle: style)
>>>>>>> master
        buttonStackView.addArrangedSubview(actionButton)

        if article.buttonKind == .normal {
            buttonStackView.addArrangedSubview(UIView(withAutoLayout: true))
        }

        actionButton.addTarget(self, action: #selector(handleActionButton), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func handleActionButton() {
        delegate?.realestateAgencyContentItemDidSelectActionButton(self)
    }
}
