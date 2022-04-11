import UIKit
import FinniversKit

public protocol ExtendedProfileViewDelegate: AnyObject {
    func extendedProfileView(_ view: ExtendedProfileView, didSelectLinkAtIndex linkIndex: Int, forContactPersonAtIndex contactPersonIndex: Int)
}

public class ExtendedProfileView: UIView {

    // MARK: - Public properties



    // MARK: - Private properties

    private let viewModel: ExtendedProfileViewModel
    private weak var delegate: ExtendedProfileViewDelegate?
    private weak var remoteImageViewDataSource: RemoteImageViewDataSource?
    private lazy var contactPersonsStackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)
    private lazy var logoView = ExtendedProfileLogoView(withAutoLayout: true)

    private lazy var sloganLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        label.textColor = viewModel.style.textColor
        return label
    }()

    // MARK: - Init

    public init(
        viewModel: ExtendedProfileViewModel,
        delegate: ExtendedProfileViewDelegate,
        remoteImageViewDataSource: RemoteImageViewDataSource,
        withAutoLayout: Bool = false
    ) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.remoteImageViewDataSource = remoteImageViewDataSource
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        layer.cornerRadius = 8
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = .sardine // TODO: Is this correct?
        backgroundColor = viewModel.style.backgroundColor

        sloganLabel.text = viewModel.slogan ?? viewModel.companyName

        addSubview(logoView)
        addSubview(sloganLabel)
        addSubview(contactPersonsStackView)

        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: topAnchor),
            logoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoView.trailingAnchor.constraint(equalTo: trailingAnchor),

            sloganLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: .spacingM),
            sloganLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            sloganLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            contactPersonsStackView.topAnchor.constraint(equalTo: sloganLabel.bottomAnchor, constant: .spacingM),
            contactPersonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            contactPersonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            contactPersonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM),
        ])

        logoView.configure(imageUrl: viewModel.logoUrl, backgroundColor: viewModel.style.logoBackgroundColor, remoteImageViewDataSource: remoteImageViewDataSource)

        // TODO: This will be different based on the placement. Only 1 will be shown for top, while all will be shown for bottom.
        let contactPersonViews = viewModel.contactPersons.enumerated().map { index, contactPerson in
            ExtendedProfileContactPersonView(
                contactPersonIndex: index,
                contactPerson: contactPerson,
                style: viewModel.style,
                remoteImageViewDataSource: remoteImageViewDataSource,
                delegate: self,
                withAutoLayout: true
            )
        }

        contactPersonsStackView.addArrangedSubviews(contactPersonViews)
    }
}

// MARK: - ExtendedProfileContactPersonViewDelegate

extension ExtendedProfileView: ExtendedProfileContactPersonViewDelegate {
    func extendedProfileContactPersonView(
        _ view: ExtendedProfileContactPersonView,
        didSelectLinkAtIndex linkIndex: Int,
        contactPersonIndex: Int
    ) {
        delegate?.extendedProfileView(self, didSelectLinkAtIndex: linkIndex, forContactPersonAtIndex: contactPersonIndex)
    }
}

public struct ExtendedProfileViewModel {
    public let companyName: String
    public let slogan: String?
    public let logoUrl: String
    public let contactPersons: [CompanyProfile.ContactPerson]
    public let style: CompanyProfile.ProfileStyle
    public let buttonLinks: [LinkButtonViewModel]
    public let actionButtonTitle: String?

    public init(
        companyName: String,
        slogan: String?,
        logoUrl: String,
        contactPersons: [CompanyProfile.ContactPerson],
        style: CompanyProfile.ProfileStyle,
        buttonLinks: [LinkButtonViewModel],
        actionButtonTitle: String?
    ) {
        self.companyName = companyName
        self.slogan = slogan
        self.logoUrl = logoUrl
        self.contactPersons = contactPersons
        self.style = style
        self.buttonLinks = buttonLinks
        self.actionButtonTitle = actionButtonTitle
    }
}
