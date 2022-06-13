import UIKit
import FinniversKit

protocol BasicProfileContactPersonViewDelegate: AnyObject {
    func basicProfileContactPersonView(
        _ view: BasicProfileContactPersonView,
        didSelectLinkItem linkItem: CompanyProfile.ContactPerson.LinkItem,
        contactPersonIndex: Int
    )
}

class BasicProfileContactPersonView: UIView {

    // MARK: - Internal properties

    weak var delegate: BasicProfileContactPersonViewDelegate?

    // MARK: - Private properties

    private let contactPersonIndex: Int
    private let contactPerson: CompanyProfile.ContactPerson
    private let linkItems: [CompanyProfile.ContactPerson.LinkItem]
    private let sendMailLinkItem: CompanyProfile.ContactPerson.LinkItem?
    private lazy var nameLabel = createLabel(style: .bodyStrong)
    private lazy var jobTitleLabel = createLabel(style: .detail)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        stackView.addArrangedSubviews([nameLabel, jobTitleLabel, linkCollectionView, sendMailButton])
        stackView.setCustomSpacing(.spacingXS, after: nameLabel)
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var linkCollectionView = OverflowCollectionView(
        cellType: ContactPersonLinkCollectionViewCell.self,
        cellSpacing: .init(horizontal: .spacingL, vertical: .spacingXS),
        delegate: self,
        withAutoLayout: true
    )

    private lazy var sendMailButton: Button = {
        let button = Button(style: .callToAction, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleSendMailTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    init(
        contactPersonIndex: Int,
        contactPerson: CompanyProfile.ContactPerson,
        delegate: BasicProfileContactPersonViewDelegate,
        withAutoLayout: Bool
    ) {
        self.contactPersonIndex = contactPersonIndex
        self.contactPerson = contactPerson
        self.delegate = delegate

        let linkItems = contactPerson.links
        sendMailLinkItem = linkItems.first { $0.kind == .sendMail }
        self.linkItems = linkItems.filter { $0.kind != .sendMail }

        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout

        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        if let sendMailLinkItem = sendMailLinkItem {
            sendMailButton.setTitle(sendMailLinkItem.title, for: .normal)
        } else {
            sendMailButton.isHidden = true
        }

        nameLabel.text = contactPerson.name
        jobTitleLabel.text = contactPerson.jobTitle

        addSubview(stackView)
        stackView.fillInSuperview()

        NSLayoutConstraint.activate([
            sendMailButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            linkCollectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])

        let linkCellModels = linkItems.map { ContactPersonLinkViewModel(title: $0.title, textColor: .btnPrimary) }
        linkCollectionView.configure(with: linkCellModels)
    }

    // MARK: - Private methods

    private func createLabel(style: Label.Style) -> Label {
        let label = Label(style: style, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }

    // MARK: - Actions

    @objc private func handleSendMailTap() {
        guard let sendMailLinkItem = sendMailLinkItem else { return }
        delegate?.basicProfileContactPersonView(self, didSelectLinkItem: sendMailLinkItem, contactPersonIndex: contactPersonIndex)
    }
}

// MARK: - OverflowCollectionViewDelegate

extension BasicProfileContactPersonView: OverflowCollectionViewDelegate {
    func overflowCollectionView<Cell>(
        _ view: OverflowCollectionView<Cell>,
        didSelectItemAtIndex index: Int
    ) where Cell: OverflowCollectionViewCell {
        guard let linkItem = linkItems[safe: index] else { return }
        delegate?.basicProfileContactPersonView(self, didSelectLinkItem: linkItem, contactPersonIndex: contactPersonIndex)
    }
}
