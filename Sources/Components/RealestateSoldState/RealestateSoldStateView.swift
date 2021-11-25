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
}

public class RealestateSoldStateView: UIView {

    // MARK: - Public properties

    public weak var delegate: RealestateSoldStateViewDelegate?

    // MARK: - Private properties

    private let viewModel: RealestateSoldStateModel
    private weak var remoteImageViewDataSource: RemoteImageViewDataSource?
    private lazy var logoImageWrapperView = RealestateAgencyLogoWrapperView(withAutoLayout: true)
    private lazy var logoBackgroundView = UIView(withAutoLayout: true)
    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)
    private lazy var agentProfileView = AgentProfileView(withAutoLayout: true)

    private lazy var titleLabel: Label = {
        let label = Label(style: .title2, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var questionFormView = QuestionFormContainerView(
        viewModel: viewModel.questionForm,
        styling: viewModel.styling,
        delegate: self,
        withAutoLayout: true
    )

    private lazy var companyProfileView = CompanyProfileView(
        viewModel: viewModel.companyProfile,
        styling: viewModel.styling,
        remoteImageViewDataSource: remoteImageViewDataSource,
        delegate: self,
        withAutoLayout: true
    )

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
        backgroundColor = .bgQuaternary
        logoBackgroundView.backgroundColor = viewModel.styling.logoBackgroundColor
        titleLabel.text = viewModel.title
        titleLabel.textColor = viewModel.styling.textColor

        stackView.addArrangedSubviews([titleLabel, questionFormView, agentProfileView, companyProfileView])
        stackView.setCustomSpacing(.spacingL, after: titleLabel)

        addSubview(logoBackgroundView)
        addSubview(logoImageWrapperView)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            logoImageWrapperView.topAnchor.constraint(equalTo: topAnchor),
            logoImageWrapperView.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoImageWrapperView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),

            logoBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            logoBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            logoBackgroundView.bottomAnchor.constraint(equalTo: logoImageWrapperView.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: logoImageWrapperView.bottomAnchor, constant: .spacingM),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM),
        ])

        logoImageWrapperView.configure(imageUrl: viewModel.logoUrl, backgroundColor: viewModel.styling.logoBackgroundColor, remoteImageViewDataSource: remoteImageViewDataSource)
        agentProfileView.configure(with: viewModel.agentProfile, remoteImageViewDataSource: remoteImageViewDataSource)
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
