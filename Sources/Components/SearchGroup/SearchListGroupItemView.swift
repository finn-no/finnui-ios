import UIKit
import FinniversKit

public struct SearchListGroupItem {
    public let title: String
    public let subtitle: String?
    public let imageUrl: String
    public let titleColor: UIColor
    public let showDeleteButton: Bool

    public init(
        title: String,
        subtitle: String?,
        imageUrl: String,
        titleColor: UIColor = .textPrimary,
        showDeleteButton: Bool
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
        self.titleColor = titleColor
        self.showDeleteButton = showDeleteButton
    }
}


protocol searchListItemViewDelegate: AnyObject {
    func searchListItemViewWasSelected(_ view: SearchListGroupItemView)
    //func searchListItemViewDidSelectRemoveButton(_ view: SearchListGroupItemView)
}

class SearchListGroupItemView: UIView {

    // MARK: - Private properties

    private let item: SearchListGroupItem
    //private weak var delegate: searchListItemViewDelegate?
    private let imageAndButtonWidth: CGFloat = 40
    private lazy var titlesStackViewTrailingConstraint = titlesStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM)
    private lazy var highlightLayer = CALayer()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: .spacingM, withAutoLayout: true)
        stackView.alignment = .center
        stackView.addArrangedSubviews([remoteImageView, titlesStackView])
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

    /*

    private lazy var removeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        let buttonImage = UIImage(named: .remove).withRenderingMode(.alwaysTemplate)
        button.setImage(buttonImage, for: .normal)
        button.imageView?.tintColor = .textPrimary
        button.addTarget(self, action: #selector(handleRemoveButtonTap), for: .touchUpInside)
        return button
    }()*/

    /// we just need a button or icon here that is configured when the cell is made - either external link icon, remove icon or no icon
    /*
    //For the frontpage search results add this to where the button was
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
     */
    // MARK: - Init

    init(
        item: SearchListGroupItem,
        remoteImageViewDataSource: RemoteImageViewDataSource,
        withAutoLayout: Bool = false
    ) {
        self.item = item
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout

        remoteImageView.dataSource = remoteImageViewDataSource
        remoteImageView.loadImage(for: item.imageUrl, imageWidth: imageAndButtonWidth)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        titleLabel.text = item.title
        titleLabel.textColor = item.titleColor
        subtitleLabel.text = item.subtitle

        addSubview(contentStackView)
        contentStackView.fillInSuperview()

        NSLayoutConstraint.activate([
            remoteImageView.heightAnchor.constraint(equalToConstant: imageAndButtonWidth),
            remoteImageView.widthAnchor.constraint(equalToConstant: imageAndButtonWidth)
        ])

        layer.insertSublayer(highlightLayer, at: 0)
    }


    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        highlightLayer.frame = bounds.insetBy(dx: -.spacingXS, dy: -.spacingXS)
        //setHighlightColor(.bgPrimary)
    }
}

