import UIKit
import FinniversKit

protocol CompanyProfileViewDelegate: AnyObject {
    func companyProfileViewDidSelectCtaButton(_ view: CompanyProfileView)
    func companyProfileView(_ view: CompanyProfileView, didTapButtonWithIdentifier identifier: String?, url: URL)
}

class CompanyProfileView: UIView {

    // MARK: - Private properties

    private weak var delegate: CompanyProfileViewDelegate?
    private lazy var logoHeaderView = CompanyProfileHeaderView(withAutoLayout: true)
    private lazy var hairlineView = UIView(withAutoLayout: true)

    private lazy var sloganLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var buttonListView: LinkButtonListView = {
        let view = LinkButtonListView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private lazy var ctaButton: Button = {
        let button = Button(style: .callToAction, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleCtaButtonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    init(delegate: CompanyProfileViewDelegate, withAutoLayout: Bool) {
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(logoHeaderView)
        addSubview(hairlineView)
        addSubview(sloganLabel)
        addSubview(buttonListView)
        addSubview(ctaButton)

        NSLayoutConstraint.activate([
            logoHeaderView.topAnchor.constraint(equalTo: topAnchor),
            logoHeaderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoHeaderView.trailingAnchor.constraint(equalTo: trailingAnchor),

            hairlineView.topAnchor.constraint(equalTo: logoHeaderView.bottomAnchor),
            hairlineView.heightAnchor.constraint(equalToConstant: 1),
            hairlineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hairlineView.trailingAnchor.constraint(equalTo: trailingAnchor),

            sloganLabel.topAnchor.constraint(equalTo: hairlineView.bottomAnchor, constant: .spacingM),
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
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.sardine.cgColor
        hairlineView.backgroundColor = .sardine
    }

    // MARK: - Internal methods

    func configure(with viewModel: CompanyProfileModel, remoteImageViewDataSource: RemoteImageViewDataSource?) {
        logoHeaderView.configure(imageUrl: viewModel.imageUrl, remoteImageViewDataSource: remoteImageViewDataSource)

        sloganLabel.text = viewModel.slogan
        buttonListView.configure(with: viewModel.buttonLinks)
        ctaButton.setTitle(viewModel.ctaButtonTitle, for: .normal)
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
