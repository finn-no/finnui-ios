import UIKit
import FinniversKit

protocol SearchDropdownGroupItemViewDelegate: AnyObject {
    func searchDropdownGroupItemViewWasSelected(_ view: SearchDropdownGroupItemView)
    func searchDropdownGroupItemViewDidSelectRemoveButton(_ view: SearchDropdownGroupItemView)
}

class SearchDropdownGroupItemView: UIView {

    // MARK: - Private properties

    private let item: SearchDropdownGroupItem
    private weak var delegate: SearchDropdownGroupItemViewDelegate?
    private lazy var titlesStackViewTrailingConstraint = titlesStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM)
    private let imageAndButtonWidth: CGFloat = 40

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

    // MARK: - Setup

    private func setup() {
        titleLabel.text = item.title
        titleLabel.textColor = item.titleColor
        subtitleLabel.text = item.subtitle
        removeButton.isHidden = !item.showDeleteButton

        addSubview(contentStackView)
        contentStackView.fillInSuperview()

        contentStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleViewSelection)))

        NSLayoutConstraint.activate([
            remoteImageView.heightAnchor.constraint(equalToConstant: imageAndButtonWidth),
            remoteImageView.widthAnchor.constraint(equalToConstant: imageAndButtonWidth),

            removeButton.heightAnchor.constraint(equalToConstant: imageAndButtonWidth),
            removeButton.widthAnchor.constraint(equalToConstant: imageAndButtonWidth)
        ])
    }

    // MARK: - Actions

    @objc private func handleViewSelection() {
        delegate?.searchDropdownGroupItemViewWasSelected(self)
    }

    @objc private func handleRemoveButtonTap() {
        delegate?.searchDropdownGroupItemViewDidSelectRemoveButton(self)
    }
}

