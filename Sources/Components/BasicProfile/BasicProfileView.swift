import UIKit
import FinniversKit

public protocol BasicProfileViewDelegate: AnyObject {
    func basicProfileView(
        _ view: BasicProfileView,
        didSelectLinkItem linkItem: CompanyProfile.ContactPerson.LinkItem,
        contactPersonIndex: Int
    )
    func basicProfileView(_ view: BasicProfileView, didSelectButtonWithIdentifier identifier: String?, url: URL)
}

public final class BasicProfileView: UIView {

    // MARK: - Private properties

    private let viewModel: BasicProfileViewModel
    private weak var delegate: BasicProfileViewDelegate?
    private weak var remoteImageViewDataSource: RemoteImageViewDataSource?
    private lazy var logoView = CompanyProfileLogoView(logoHeight: 80, verticalSpacing: .spacingM, withAutoLayout: true)
    private lazy var contentStackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)
    private lazy var contactPersonsStackView = UIStackView(axis: .vertical, spacing: .spacingL, withAutoLayout: true)

    private lazy var companyNameLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var buttonListView: LinkButtonListView = {
        let view = LinkButtonListView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    // MARK: - Init

    public init(
        viewModel: BasicProfileViewModel,
        delegate: BasicProfileViewDelegate?,
        remoteImageViewDataSource: RemoteImageViewDataSource?,
        withAutoLayout: Bool = false
    ) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.remoteImageViewDataSource = remoteImageViewDataSource
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        layer.cornerRadius = 8
        clipsToBounds = true
        backgroundColor = .bgTertiary
        layer.borderWidth = 1

        addSubview(logoView)
        addSubview(contentStackView)

        contentStackView.addArrangedSubviews([companyNameLabel, contactPersonsStackView, buttonListView])
        contentStackView.setCustomSpacing(.spacingL, after: contactPersonsStackView)

        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: topAnchor),
            logoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoView.trailingAnchor.constraint(equalTo: trailingAnchor),

            contentStackView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: .spacingM),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM),
        ])

        companyNameLabel.text = viewModel.companyName
        logoView.configure(imageUrl: viewModel.logoUrl, backgroundColor: .white, remoteImageViewDataSource: remoteImageViewDataSource)
        buttonListView.configure(with: viewModel.buttonLinks)

        let contactPersonViews = viewModel.contactPersons.enumerated().map { index, contactPerson in
            BasicProfileContactPersonView(
                contactPersonIndex: index,
                contactPerson: contactPerson,
                delegate: self,
                withAutoLayout: true
            )
        }

        contactPersonsStackView.addArrangedSubviews(contactPersonViews)
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()

        layer.borderColor = UIColor.borderColor.cgColor
    }
}

// MARK: - BasicProfileContactPersonViewDelegate

extension BasicProfileView: BasicProfileContactPersonViewDelegate {
    func basicProfileContactPersonView(
        _ view: BasicProfileContactPersonView,
        didSelectLinkItem linkItem: CompanyProfile.ContactPerson.LinkItem,
        contactPersonIndex: Int
    ) {
        delegate?.basicProfileView(self, didSelectLinkItem: linkItem, contactPersonIndex: contactPersonIndex)
    }
}

// MARK: - LinkButtonListViewDelegate

extension BasicProfileView: LinkButtonListViewDelegate {
    public func linksListView(_ view: LinkButtonListView, didTapButtonWithIdentifier identifier: String?, url: URL) {
        delegate?.basicProfileView(self, didSelectButtonWithIdentifier: identifier, url: url)
    }
}

// MARK: - Private extensions

private extension UIColor {
    static var borderColor: UIColor {
        .dynamicColor(defaultColor: .sardine, darkModeColor: .darkSardine)
    }
}
