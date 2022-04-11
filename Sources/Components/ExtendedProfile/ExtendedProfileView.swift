import UIKit
import FinniversKit

public protocol ExtendedProfileViewDelegate: AnyObject {
    func extendedProfileView(_ view: ExtendedProfileView, didSelectLinkAtIndex linkIndex: Int, forContactPersonAtIndex contactPersonIndex: Int)
    func extendedProfileView(_ view: ExtendedProfileView, didSelectButtonWithIdentifier identifier: String?, url: URL)
    func extendedProfileViewDidSelectActionButton(_ view: ExtendedProfileView)
    func extendedProfileViewDidToggleExpandedState(_ view: ExtendedProfileView)
}

public class ExtendedProfileView: UIView {

    // MARK: - Public properties

    public var isExpanded: Bool = false {
        didSet {
            configurePresentation()
        }
    }

    // MARK: - Private properties

    private let viewModel: ExtendedProfileViewModel
    private weak var delegate: ExtendedProfileViewDelegate?
    private weak var remoteImageViewDataSource: RemoteImageViewDataSource?
    private lazy var contentStackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)
    private lazy var contactPersonsStackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)
    private lazy var logoView = ExtendedProfileLogoView(withAutoLayout: true)
    private lazy var contentStackViewBottomAnchor = contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM)

    private lazy var headerView: ExtendedProfileHeaderView = {
        let view = ExtendedProfileHeaderView(viewModel: viewModel, withAutoLayout: true)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleExpandStateTap)))
        return view
    }()

    private lazy var buttonListView: LinkButtonListView = {
        let view = LinkButtonListView(withAutoLayout: true)
        view.delegate = self
        return view
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

        addSubview(logoView)
        addSubview(headerView)
        addSubview(contentStackView)

        contentStackView.addArrangedSubviews([contactPersonsStackView, buttonListView])

        if let actionButton = createActionButtonIfPossible() {
            contentStackView.addArrangedSubview(actionButton)
        }

        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: topAnchor),
            logoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoView.trailingAnchor.constraint(equalTo: trailingAnchor),

            headerView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: .spacingM),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            contentStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: .spacingM),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            contentStackViewBottomAnchor
        ])

        configurePresentation()

        logoView.configure(imageUrl: viewModel.logoUrl, backgroundColor: viewModel.style.logoBackgroundColor, remoteImageViewDataSource: remoteImageViewDataSource)
        buttonListView.configure(with: viewModel.buttonLinks)

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

    // MARK: - Private methods

    private func configurePresentation() {
        contentStackView.arrangedSubviews.forEach {
            $0.isHidden = !isExpanded
        }

        headerView.configure(isExpanded: isExpanded)
        contentStackViewBottomAnchor.constant = isExpanded ? -.spacingM : .zero
    }

    private func createActionButtonIfPossible() -> Button? {
        guard
            let actionButtonStyle = viewModel.style.actionButtonStyle,
            let buttonTitle = viewModel.actionButtonTitle
        else {
            return nil
        }

        let button = Button(style: .callToAction.override(using: actionButtonStyle), size: .normal, withAutoLayout: true)
        button.setTitle(buttonTitle, for: .normal)
        button.addTarget(self, action: #selector(handleActionButtonTap), for: .touchUpInside)
        return button
    }

    // MARK: - Actions

    @objc private func handleActionButtonTap() {
        delegate?.extendedProfileViewDidSelectActionButton(self)
    }

    @objc private func handleExpandStateTap() {
        delegate?.extendedProfileViewDidToggleExpandedState(self)
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

// MARK: - LinkButtonListViewDelegate

extension ExtendedProfileView: LinkButtonListViewDelegate {
    public func linksListView(_ view: LinkButtonListView, didTapButtonWithIdentifier identifier: String?, url: URL) {
        delegate?.extendedProfileView(self, didSelectButtonWithIdentifier: identifier, url: url)
    }
}
