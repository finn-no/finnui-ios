import UIKit
import FinniversKit

protocol AgentProfileViewDelegate: AnyObject {
    func agentProfileView(_ view: AgentProfileView, didSelectLinkItem linkItem: CompanyProfile.ContactPerson.LinkItem)
}

class AgentProfileView: UIView {

    // MARK: - Internal properties

    weak var delegate: AgentProfileViewDelegate?

    // MARK: - Private properties

    private let numberOfPhoneNumbersPerRow = 2
    private let portraitImageSize: CGFloat = 88
    private var contactPerson: CompanyProfile.ContactPerson?
    private lazy var textStackView = UIStackView(axis: .vertical, spacing: .spacingXS, withAutoLayout: true)
    private lazy var contactStackView = UIStackView(axis: .horizontal, spacing: .spacingM, withAutoLayout: true)
    private lazy var titleLabel = Label.create(style: .title3Strong)
    private lazy var nameLabel = Label.create(style: .bodyStrong)
    private lazy var jobTitleLabel = Label.create(style: .detail)

    private lazy var phoneNumbersCollectionView = OverflowCollectionView(
        cellType: ContactPersonLinkCollectionViewCell.self,
        cellSpacing: .init(horizontal: 24, vertical: .spacingXS),
        delegate: self,
        withAutoLayout: true
    )

    private lazy var portraitImageView: RemoteImageView = {
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

            portraitImageView.heightAnchor.constraint(equalToConstant: portraitImageSize),
            portraitImageView.widthAnchor.constraint(equalToConstant: portraitImageSize),

            contactStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingM),
            contactStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contactStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contactStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - Internal methods

    func configure(with contactPerson: CompanyProfile.ContactPerson, remoteImageViewDataSource: RemoteImageViewDataSource?) {
        self.contactPerson = contactPerson
        titleLabel.text = contactPerson.title
        nameLabel.text = contactPerson.name
        jobTitleLabel.text = contactPerson.jobTitle

        let linkCellModels = contactPerson.links.map { ContactPersonLinkViewModel(title: $0.title, textColor: .textAction) }
        phoneNumbersCollectionView.configure(with: linkCellModels)

        portraitImageView.dataSource = remoteImageViewDataSource

        if let imageUrl = contactPerson.imageUrl {
            portraitImageView.loadImage(for: imageUrl, imageWidth: portraitImageSize)
            contactStackView.insertArrangedSubview(portraitImageView, at: 0)
        } else {
            portraitImageView.removeFromSuperview()
        }
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        portraitImageView.layer.cornerRadius = portraitImageSize / 2
    }
}

// MARK: - OverflowCollectionViewDelegate

extension AgentProfileView: OverflowCollectionViewDelegate {
    func overflowCollectionView<Cell>(
        _ view: OverflowCollectionView<Cell>,
        didSelectItemAtIndex index: Int
    ) where Cell: OverflowCollectionViewCell {
        guard let linkItem = contactPerson?.links[safe: index] else { return }
        delegate?.agentProfileView(self, didSelectLinkItem: linkItem)
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
