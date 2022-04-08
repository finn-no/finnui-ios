import UIKit
import FinniversKit

protocol AgentProfileViewDelegate: AnyObject {
    func agentProfileView(_ view: AgentProfileView, didSelectPhoneButtonWithIndex phoneNumberIndex: Int)
}

class AgentProfileView: UIView {

    // MARK: - Internal properties

    weak var delegate: AgentProfileViewDelegate?

    // MARK: - Private properties

    private let numberOfPhoneNumbersPerRow = 2
    private lazy var textStackView = UIStackView(axis: .vertical, spacing: .spacingXS, withAutoLayout: true)
    private lazy var contactStackView = UIStackView(axis: .horizontal, spacing: .spacingM, withAutoLayout: true)
    private lazy var titleLabel = Label.create(style: .title3Strong)
    private lazy var nameLabel = Label.create(style: .bodyStrong)
    private lazy var jobTitleLabel = Label.create(style: .detail)
    private lazy var imageSize = CGSize(width: 88, height: 88)

    private lazy var phoneNumbersCollectionView = OverflowCollectionView(
        cellType: ContactPersonLinkCollectionViewCell.self,
        cellSpacing: .init(horizontal: 24, vertical: .spacingXS),
        delegate: self,
        withAutoLayout: true
    )

    private lazy var remoteImageView: RemoteImageView = {
        let view = RemoteImageView(withAutoLayout: true)
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }()

    // MARK: - Init

    init(delegate: AgentProfileViewDelegate, withAutoLayout: Bool) {
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        contactStackView.alignment = .top
        textStackView.addArrangedSubviews([nameLabel, jobTitleLabel, phoneNumbersCollectionView])
        textStackView.setCustomSpacing(.spacingXS, after: jobTitleLabel)

        addSubview(titleLabel)
        addSubview(contactStackView)
        contactStackView.addArrangedSubview(textStackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            remoteImageView.heightAnchor.constraint(equalToConstant: imageSize.height),
            remoteImageView.widthAnchor.constraint(equalToConstant: imageSize.width),

            contactStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingM),
            contactStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contactStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contactStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - Internal methods

    func configure(with model: CompanyProfile.ContactPerson, remoteImageViewDataSource: RemoteImageViewDataSource?) {
        titleLabel.text = model.title
        nameLabel.text = model.name
        jobTitleLabel.text = model.jobTitle
        phoneNumbersCollectionView.configure(with: model.phoneNumbers)
        remoteImageView.dataSource = remoteImageViewDataSource

        if let imageUrl = model.imageUrl {
            remoteImageView.loadImage(for: imageUrl, imageWidth: imageSize.width)
            contactStackView.insertArrangedSubview(remoteImageView, at: 0)
        } else {
            remoteImageView.removeFromSuperview()
        }
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        remoteImageView.layer.cornerRadius = min(imageSize.height, imageSize.width) / 2
    }
}

// MARK: - OverflowCollectionViewDelegate

extension AgentProfileView: OverflowCollectionViewDelegate {
    func overflowCollectionView<Cell>(
        _ view: OverflowCollectionView<Cell>,
        didSelectItemAtIndex index: Int
    ) where Cell: OverflowCollectionViewCell {
        delegate?.agentProfileView(self, didSelectPhoneButtonWithIndex: index)
    }
}

// MARK: - Private extensions

private extension Label {
    static func create(style: Label.Style) -> Label {
        let label = Label(style: style, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }
}
