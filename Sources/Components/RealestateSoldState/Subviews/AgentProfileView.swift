import UIKit
import FinniversKit

protocol AgentProfileViewDelegate: AnyObject {
<<<<<<< HEAD
    func agentProfileView(_ view: AgentProfileView, didSelectPhoneButtonWithIndex phoneNumberIndex: Int)
=======
    func agentProfileView(_ view: AgentProfileView, didSelectLinkItem linkItem: CompanyProfile.ContactPerson.LinkItem)
>>>>>>> master
}

class AgentProfileView: UIView {

    // MARK: - Internal properties

    weak var delegate: AgentProfileViewDelegate?

    // MARK: - Private properties

    private let numberOfPhoneNumbersPerRow = 2
<<<<<<< HEAD
    private lazy var textStackView = UIStackView(axis: .vertical, spacing: .spacingXS, withAutoLayout: true)
    private lazy var contactStackView = UIStackView(axis: .horizontal, spacing: .spacingM, withAutoLayout: true)
    private lazy var titleLabel = Label.create(style: .title3Strong)
    private lazy var nameLabel = Label.create(style: .bodyStrong)
    private lazy var jobTitleLabel = Label.create(style: .detail)
    private lazy var imageSize = CGSize(width: 88, height: 88)

    private lazy var phoneNumbersCollectionView = OverflowCollectionView(
        cellType: AgentPhoneNumberCollectionViewCell.self,
=======
    private let portraitImageSize: CGFloat = 88
    private var contactPerson: CompanyProfile.ContactPerson?
    private lazy var textStackView = UIStackView(axis: .vertical, spacing: .spacingXS, withAutoLayout: true)
    private lazy var contactStackView = UIStackView(axis: .horizontal, spacing: .spacingM, withAutoLayout: true)
    private lazy var portraitImageView = ContactPersonImageView(withAutoLayout: true)
    private lazy var titleLabel = Label.create(style: .title3Strong)
    private lazy var nameLabel = Label.create(style: .bodyStrong)
    private lazy var jobTitleLabel = Label.create(style: .detail)

    private lazy var phoneNumbersCollectionView = OverflowCollectionView(
        cellType: ContactPersonLinkCollectionViewCell.self,
>>>>>>> master
        cellSpacing: .init(horizontal: 24, vertical: .spacingXS),
        delegate: self,
        withAutoLayout: true
    )

<<<<<<< HEAD
    private lazy var remoteImageView: RemoteImageView = {
        let view = RemoteImageView(withAutoLayout: true)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }()

=======
>>>>>>> master
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

<<<<<<< HEAD
            remoteImageView.heightAnchor.constraint(equalToConstant: imageSize.height),
            remoteImageView.widthAnchor.constraint(equalToConstant: imageSize.width),
=======
            portraitImageView.heightAnchor.constraint(equalToConstant: portraitImageSize),
            portraitImageView.widthAnchor.constraint(equalToConstant: portraitImageSize),
>>>>>>> master

            contactStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingM),
            contactStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contactStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contactStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - Internal methods

<<<<<<< HEAD
    func configure(with model: AgentProfileModel, remoteImageViewDataSource: RemoteImageViewDataSource?) {
        titleLabel.text = model.title
        nameLabel.text = model.agentName
        jobTitleLabel.text = model.agentJobTitle
        phoneNumbersCollectionView.configure(with: model.phoneNumbers)
        remoteImageView.dataSource = remoteImageViewDataSource

        if let imageUrl = model.imageUrl {
            remoteImageView.loadImage(for: imageUrl, imageWidth: imageSize.width)
            contactStackView.insertArrangedSubview(remoteImageView, at: 0)
        } else {
            remoteImageView.removeFromSuperview()
=======
    func configure(with contactPerson: CompanyProfile.ContactPerson, remoteImageViewDataSource: RemoteImageViewDataSource?) {
        self.contactPerson = contactPerson
        titleLabel.text = contactPerson.title
        nameLabel.text = contactPerson.name
        jobTitleLabel.text = contactPerson.jobTitle

        let linkCellModels = contactPerson.links.map { ContactPersonLinkViewModel(title: $0.title, textColor: .textAction) }
        phoneNumbersCollectionView.configure(with: linkCellModels)

        portraitImageView.dataSource = remoteImageViewDataSource

        if let jobTitle = contactPerson.jobTitle {
            jobTitleLabel.text = jobTitle
            jobTitleLabel.isHidden = false
        } else {
            jobTitleLabel.isHidden = true
        }

        if let imageUrl = contactPerson.imageUrl {
            portraitImageView.loadImage(for: imageUrl, imageWidth: portraitImageSize)
            contactStackView.insertArrangedSubview(portraitImageView, at: 0)
        } else {
            portraitImageView.removeFromSuperview()
>>>>>>> master
        }
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
<<<<<<< HEAD
        remoteImageView.layer.cornerRadius = min(imageSize.height, imageSize.width) / 2
=======
        portraitImageView.layer.cornerRadius = portraitImageSize / 2
>>>>>>> master
    }
}

// MARK: - OverflowCollectionViewDelegate

extension AgentProfileView: OverflowCollectionViewDelegate {
    func overflowCollectionView<Cell>(
        _ view: OverflowCollectionView<Cell>,
        didSelectItemAtIndex index: Int
    ) where Cell: OverflowCollectionViewCell {
<<<<<<< HEAD
        delegate?.agentProfileView(self, didSelectPhoneButtonWithIndex: index)
=======
        guard let linkItem = contactPerson?.links[safe: index] else { return }
        delegate?.agentProfileView(self, didSelectLinkItem: linkItem)
>>>>>>> master
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
