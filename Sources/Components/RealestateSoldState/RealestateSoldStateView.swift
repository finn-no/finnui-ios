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
    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)
    private lazy var questionFormView = QuestionFormContainerView(viewModel: viewModel.questionForm, delegate: self, withAutoLayout: true)
    private lazy var agentProfileView = AgentProfileView(withAutoLayout: true)
    private lazy var companyProfileView = CompanyProfileView(delegate: self, withAutoLayout: true)

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
        stackView.addArrangedSubviews([questionFormView, agentProfileView, companyProfileView])
        addSubview(stackView)
        stackView.fillInSuperview(insets: UIEdgeInsets(top: 0, left: .spacingM, bottom: 0, right: -.spacingM))

        agentProfileView.configure(with: viewModel.agentProfile, remoteImageViewDataSource: remoteImageViewDataSource)
        companyProfileView.configure(with: viewModel.companyProfile, remoteImageViewDataSource: remoteImageViewDataSource)
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
