import UIKit
import FinniversKit

public protocol RealestateSoldStateViewDelegate: AnyObject {
    func realestateSoldStateView(_ view: RealestateSoldStateView, didSubmitForm form: RealestateSoldStateQuestionFormSubmit)
    func realestateSoldStateViewDidSubmitFormWithoutContactInformation(
        _ view: RealestateSoldStateView,
        questionModels: [RealestateSoldStateQuestionModel]
    )
    func realestateSoldStateViewDidSelectCompanyProfileCtaButton(_ view: RealestateSoldStateView)
    func realestateSoldStateView(_ view: RealestateSoldStateView, didTapCompanyProfileButtonWithIdentifier identifier: String?, url: URL)
    func realestateSoldStateViewDidToggleExpandedState(_ view: RealestateSoldStateView)
    func realestateSoldStateViewDidResize(_ view: RealestateSoldStateView)
    func realestateSoldStateView(_ view: RealestateSoldStateView, didSelectPhoneButtonWithIndex phoneNumberIndex: Int)
}

public class RealestateSoldStateView: UIView {

    // MARK: - Public properties

    public weak var delegate: RealestateSoldStateViewDelegate?

    public var isExpanded: Bool = false {
        didSet {
            configurePresentation(updateStackViewConstraints: false)
        }
    }

    // MARK: - Private properties

    private let viewModel: RealestateSoldStateModel
    private let expandToggleViewHeight = CGFloat(56)
    private var presentQuestionForm = true
    private weak var remoteImageViewDataSource: RemoteImageViewDataSource?
    private lazy var backgroundView = UIView(withAutoLayout: true)
    private lazy var logoImageWrapperView = RealestateAgencyLogoWrapperView(withAutoLayout: true)
    private lazy var logoBackgroundView = UIView(withAutoLayout: true)
    private lazy var agentProfileView = AgentProfileView(delegate: self, withAutoLayout: true)
    private lazy var expandToggleView = RealestateSoldStateExpandToggleView(withAutoLayout: true)
    private lazy var leftStackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)
    private lazy var rightStackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)

    private lazy var regularScreenConstraints: [NSLayoutConstraint] = [
        leftStackView.topAnchor.constraint(equalTo: logoImageWrapperView.bottomAnchor, constant: .spacingM),
        leftStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
        leftStackView.bottomAnchor.constraint(lessThanOrEqualTo: backgroundView.bottomAnchor, constant: -.spacingM),

        rightStackView.topAnchor.constraint(equalTo: logoImageWrapperView.bottomAnchor, constant: .spacingM),
        rightStackView.leadingAnchor.constraint(equalTo: leftStackView.trailingAnchor, constant: .spacingM),
        rightStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
        rightStackView.bottomAnchor.constraint(lessThanOrEqualTo: backgroundView.bottomAnchor, constant: -.spacingM),
        rightStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 2/5)
    ]

    private lazy var compactScreenConstraints: [NSLayoutConstraint] = [
        leftStackView.topAnchor.constraint(equalTo: logoImageWrapperView.bottomAnchor, constant: .spacingM),
        leftStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
        leftStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

        rightStackView.topAnchor.constraint(equalTo: leftStackView.bottomAnchor, constant: .spacingM),
        rightStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
        rightStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
        rightStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -.spacingM)
    ]

    private lazy var titleLabel: Label = {
        let label = Label(style: .title2, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var formSubmittedLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var questionFormView = QuestionFormContainerView(
        viewModel: viewModel.questionForm,
        style: viewModel.style,
        delegate: self,
        withAutoLayout: true
    )

    private lazy var companyProfileView = CompanyProfileView(
        viewModel: viewModel.companyProfile,
        style: viewModel.style.profileStyle,
        remoteImageViewDataSource: remoteImageViewDataSource,
        delegate: self,
        withAutoLayout: true
    )

    private lazy var presentFormButton: Button = {
        let button = Button(style: .callToAction.override(using: viewModel.style.actionButtonStyle), size: .normal, withAutoLayout: true)
        button.setTitle(viewModel.presentFormButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(presentFormButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    public init(viewModel: RealestateSoldStateModel, remoteImageViewDataSource: RemoteImageViewDataSource, withAutoLayout: Bool = false) {
        self.viewModel = viewModel
        self.remoteImageViewDataSource = remoteImageViewDataSource
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .clear
        backgroundView.backgroundColor = .bgTertiary
        expandToggleView.backgroundColor = .bgTertiary
        logoBackgroundView.backgroundColor = viewModel.style.headingStyle.backgroundColor
        titleLabel.text = viewModel.title

        leftStackView.addArrangedSubviews([titleLabel, questionFormView, presentFormButton])
        leftStackView.setCustomSpacing(.spacingL, after: titleLabel)

        rightStackView.addArrangedSubviews([agentProfileView, companyProfileView])
        rightStackView.distribution = .equalCentering

        addSubview(backgroundView)
        addSubview(expandToggleView)
        addSubview(logoBackgroundView)
        addSubview(logoImageWrapperView)
        addSubview(leftStackView)
        addSubview(rightStackView)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(expandToggleViewHeight / 2)),

            logoImageWrapperView.topAnchor.constraint(equalTo: topAnchor),
            logoImageWrapperView.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoImageWrapperView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),

            logoBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            logoBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            logoBackgroundView.bottomAnchor.constraint(equalTo: logoImageWrapperView.bottomAnchor),

            expandToggleView.bottomAnchor.constraint(equalTo: bottomAnchor),
            expandToggleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            expandToggleView.heightAnchor.constraint(equalToConstant: expandToggleViewHeight),
            expandToggleView.widthAnchor.constraint(equalToConstant: expandToggleViewHeight)
        ])

        configurePresentation(updateStackViewConstraints: true)

        expandToggleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleExpandViewTap)))

        logoImageWrapperView.configure(imageUrl: viewModel.logoUrl, backgroundColor: viewModel.style.headingStyle.logoBackgroundColor, remoteImageViewDataSource: remoteImageViewDataSource)
        agentProfileView.configure(with: viewModel.contactPerson, remoteImageViewDataSource: remoteImageViewDataSource)
    }

    // MARK: - Overrides

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass {
            configurePresentation(updateStackViewConstraints: true)
        }
    }

    // MARK: - Public methods

    public func hideFormAndPresentSuccessLabel(notifyDelegateAboutResize notifyDelegate: Bool = false) {
        presentQuestionForm = false
        configurePresentation(updateStackViewConstraints: true)

        if notifyDelegate {
            delegate?.realestateSoldStateViewDidResize(self)
        }
    }

    // MARK: - Private methods

    private func configurePresentation(updateStackViewConstraints: Bool) {
        if presentQuestionForm {
            if isExpanded {
                questionFormView.isHidden = false
                companyProfileView.isHidden = false
                presentFormButton.isHidden = true
                expandToggleView.configure(with: UIImage(named: .chevronUp))
            } else {
                questionFormView.isHidden = true
                companyProfileView.isHidden = true
                presentFormButton.isHidden = false
                expandToggleView.configure(with: UIImage(named: .chevronDown))
            }
        } else {
            questionFormView.isHidden = true
            presentFormButton.isHidden = true
            companyProfileView.isHidden = false
            expandToggleView.removeFromSuperview()
            leftStackView.addArrangedSubview(formSubmittedLabel)

            titleLabel.text = viewModel.formSubmitted.title
            formSubmittedLabel.text = viewModel.formSubmitted.description
        }

        if updateStackViewConstraints {
            switch traitCollection.horizontalSizeClass {
            case .regular:
                NSLayoutConstraint.deactivate(compactScreenConstraints)
                NSLayoutConstraint.activate(regularScreenConstraints)
            default:
                NSLayoutConstraint.deactivate(regularScreenConstraints)
                NSLayoutConstraint.activate(compactScreenConstraints)
            }
        }
    }

    // MARK: - Actions

    @objc private func presentFormButtonTapped() {
        delegate?.realestateSoldStateViewDidToggleExpandedState(self)
    }

    @objc private func handleExpandViewTap() {
        delegate?.realestateSoldStateViewDidToggleExpandedState(self)
    }
}

// MARK: - QuestionFormContainerViewDelegate

extension RealestateSoldStateView: QuestionFormContainerViewDelegate {
    func questionFormContainerView(_ view: QuestionFormContainerView, didSubmitForm form: RealestateSoldStateQuestionFormSubmit) {
        delegate?.realestateSoldStateView(self, didSubmitForm: form)
    }

    func questionFormContainerViewDidSubmitFormWithoutContactInformation(
        _ view: QuestionFormContainerView,
        questionModels: [RealestateSoldStateQuestionModel]
    ) {
        delegate?.realestateSoldStateViewDidSubmitFormWithoutContactInformation(self, questionModels: questionModels)
    }

    func questionFormContainerViewDidToggleTextView(_ view: QuestionFormContainerView) {
        delegate?.realestateSoldStateViewDidResize(self)
    }
}

// MARK: - CompanyProfileViewDelegate

extension RealestateSoldStateView: CompanyProfileViewDelegate {
    func companyProfileViewDidSelectCtaButton(_ view: CompanyProfileView) {
        delegate?.realestateSoldStateViewDidSelectCompanyProfileCtaButton(self)
    }

    func companyProfileView(_ view: CompanyProfileView, didTapButtonWithIdentifier identifier: String?, url: URL) {
        delegate?.realestateSoldStateView(self, didTapCompanyProfileButtonWithIdentifier: identifier, url: url)
    }
}

// MARK: - AgentProfileViewDelegate

extension RealestateSoldStateView: AgentProfileViewDelegate {
    func agentProfileView(_ view: AgentProfileView, didSelectPhoneButtonWithIndex phoneNumberIndex: Int) {
        delegate?.realestateSoldStateView(self, didSelectPhoneButtonWithIndex: phoneNumberIndex)
    }
}
