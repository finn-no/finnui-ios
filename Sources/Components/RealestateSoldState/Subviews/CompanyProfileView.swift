import UIKit
import FinniversKit

protocol CompanyProfileViewDelegate: AnyObject {
    func companyProfileViewDidSelectCtaButton(_ view: CompanyProfileView)
    func companyProfileView(_ view: CompanyProfileView, didTapButtonWithIdentifier identifier: String?, url: URL)
}

class CompanyProfileView: UIView {

    // MARK: - Private properties

    private let viewModel: CompanyProfileModel
<<<<<<< HEAD
    private let styling: RealestateSoldStateModel.Styling.ProfileBoxStyle
=======
    private let style: CompanyProfile.ProfileStyle
>>>>>>> master
    private weak var delegate: CompanyProfileViewDelegate?
    private lazy var logoHeaderView = CompanyProfileHeaderView(withAutoLayout: true)

    private lazy var sloganLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
<<<<<<< HEAD
        label.textColor = styling.textColor
=======
        label.textColor = style.textColor
>>>>>>> master
        return label
    }()

    private lazy var buttonListView: LinkButtonListView = {
        let view = LinkButtonListView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private lazy var ctaButton: Button = {
<<<<<<< HEAD
        let button = Button(style: .callToAction.override(using: styling.actionButton), size: .normal, withAutoLayout: true)
=======
        let button = Button(style: .callToAction.override(using: style.actionButtonStyle), size: .normal, withAutoLayout: true)
>>>>>>> master
        button.addTarget(self, action: #selector(handleCtaButtonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    init(
        viewModel: CompanyProfileModel,
<<<<<<< HEAD
        styling: RealestateSoldStateModel.Styling.ProfileBoxStyle,
=======
        style: CompanyProfile.ProfileStyle,
>>>>>>> master
        remoteImageViewDataSource: RemoteImageViewDataSource?,
        delegate: CompanyProfileViewDelegate,
        withAutoLayout: Bool
    ) {
        self.viewModel = viewModel
<<<<<<< HEAD
        self.styling = styling
=======
        self.style = style
>>>>>>> master
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup(remoteImageViewDataSource: remoteImageViewDataSource)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup(remoteImageViewDataSource: RemoteImageViewDataSource?) {
        clipsToBounds = true
<<<<<<< HEAD
        backgroundColor = styling.backgroundColor
=======
        backgroundColor = style.backgroundColor
>>>>>>> master
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

<<<<<<< HEAD
        logoHeaderView.configure(backgroundColor: styling.logoBackgroundColor, imageUrl: viewModel.imageUrl, remoteImageViewDataSource: remoteImageViewDataSource)

        sloganLabel.text = viewModel.slogan
        buttonListView.configure(with: viewModel.buttonLinks.map { $0.overrideStyle(using: styling) })
=======
        logoHeaderView.configure(backgroundColor: style.logoBackgroundColor, imageUrl: viewModel.imageUrl, remoteImageViewDataSource: remoteImageViewDataSource)

        sloganLabel.text = viewModel.slogan
        buttonListView.configure(with: viewModel.buttonLinks.map { $0.overrideStyle(using: style) })
>>>>>>> master
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
<<<<<<< HEAD
    func overrideStyle(using styling: RealestateSoldStateModel.Styling.ProfileBoxStyle) -> LinkButtonViewModel {
        guard let buttonStyle = buttonStyle else { return self }

        let newButtonStyle = buttonStyle.overrideStyle(
            textColor: styling.textColor,
            highlightedTextColor: styling.textColor.withAlphaComponent(0.6)
=======
    func overrideStyle(using profileStyle: CompanyProfile.ProfileStyle) -> LinkButtonViewModel {
        guard let buttonStyle = buttonStyle else { return self }

        let newButtonStyle = buttonStyle.overrideStyle(
            textColor: profileStyle.textColor,
            highlightedTextColor: profileStyle.textColor.withAlphaComponent(0.6)
>>>>>>> master
        )

        return LinkButtonViewModel(
            buttonIdentifier: buttonIdentifier,
            buttonTitle: buttonTitle,
            subtitle: subtitle,
            linkUrl: linkUrl,
            isExternal: isExternal,
<<<<<<< HEAD
            externalIconColor: styling.textColor,
=======
            externalIconColor: profileStyle.textColor,
>>>>>>> master
            buttonStyle: newButtonStyle,
            buttonSize: buttonSize
        )
    }
}
