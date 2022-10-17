import UIKit
import FinniversKit

protocol CompanyProfileViewDelegate: AnyObject {
    func companyProfileViewDidSelectCtaButton(_ view: CompanyProfileView)
    func companyProfileView(_ view: CompanyProfileView, didTapButtonWithIdentifier identifier: String?, url: URL)
}

class CompanyProfileView: UIView {

    // MARK: - Private properties

    private let viewModel: CompanyProfileModel
    private let style: CompanyProfile.ProfileStyle
    private weak var delegate: CompanyProfileViewDelegate?
    private lazy var logoHeaderView = CompanyProfileHeaderView(withAutoLayout: true)

    private lazy var sloganLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        label.textColor = style.textColor
        return label
    }()

    private lazy var buttonListView: LinkButtonListView = {
        let view = LinkButtonListView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private lazy var ctaButton: Button = {
        let button = Button(style: .callToAction.override(using: style.actionButtonStyle), size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleCtaButtonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    init(
        viewModel: CompanyProfileModel,
        style: CompanyProfile.ProfileStyle,
        remoteImageViewDataSource: RemoteImageViewDataSource?,
        delegate: CompanyProfileViewDelegate,
        withAutoLayout: Bool
    ) {
        self.viewModel = viewModel
        self.style = style
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup(remoteImageViewDataSource: remoteImageViewDataSource)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup(remoteImageViewDataSource: RemoteImageViewDataSource?) {
        clipsToBounds = true
        backgroundColor = style.backgroundColor
        layer.borderColor = UIColor.companyProfileBorder.cgColor

        addSubview(logoHeaderView)
        addSubview(sloganLabel)
        addSubview(buttonListView)
        addSubview(ctaButton)

        NSLayoutConstraint.activate([
            logoHeaderView.topAnchor.constraint(equalTo: topAnchor),
            logoHeaderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoHeaderView.trailingAnchor.constraint(equalTo: trailingAnchor),

            sloganLabel.topAnchor.constraint(equalTo: logoHeaderView.bottomAnchor, constant: .spacingM),
            sloganLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            sloganLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            buttonListView.topAnchor.constraint(equalTo: sloganLabel.bottomAnchor, constant: .spacingM),
            buttonListView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            buttonListView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            ctaButton.topAnchor.constraint(equalTo: buttonListView.bottomAnchor, constant: .spacingM),
            ctaButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            ctaButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            ctaButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM)
        ])

        logoHeaderView.configure(backgroundColor: style.logoBackgroundColor, imageUrl: viewModel.imageUrl, remoteImageViewDataSource: remoteImageViewDataSource)

        sloganLabel.text = viewModel.slogan
        buttonListView.configure(with: viewModel.buttonLinks.map { $0.overrideStyle(using: style) })
        ctaButton.setTitle(viewModel.ctaButtonTitle, for: .normal)
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.companyProfileBorder.cgColor
    }

    // MARK: - Actions

    @objc private func handleCtaButtonTap() {
        delegate?.companyProfileViewDidSelectCtaButton(self)
    }
}

// MARK: - LinkButtonListViewDelegate

extension CompanyProfileView: LinkButtonListViewDelegate {
    func linksListView(_ view: LinkButtonListView, didTapButtonWithIdentifier identifier: String?, url: URL) {
        delegate?.companyProfileView(self, didTapButtonWithIdentifier: identifier, url: url)
    }
}

// MARK: - Private extensions

private extension UIColor {
    static var companyProfileBorder = dynamicColor(defaultColor: .sardine, darkModeColor: .darkSardine)
}

private extension LinkButtonViewModel {
    func overrideStyle(using profileStyle: CompanyProfile.ProfileStyle) -> LinkButtonViewModel {
        guard let buttonStyle = buttonStyle else { return self }

        let newButtonStyle = buttonStyle.overrideStyle(
            textColor: profileStyle.textColor,
            highlightedTextColor: profileStyle.textColor.withAlphaComponent(0.6)
        )

        return LinkButtonViewModel(
            buttonIdentifier: buttonIdentifier,
            buttonTitle: buttonTitle,
            subtitle: subtitle,
            linkUrl: linkUrl,
            isExternal: isExternal,
            externalIconColor: profileStyle.textColor,
            buttonStyle: newButtonStyle,
            buttonSize: buttonSize
        )
    }
}
