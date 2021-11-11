import UIKit
import FinniversKit

public protocol RealestateSoldStateViewDelegate: AnyObject {
    func realestateSoldStateView(_ view: RealestateSoldStateView, didSubmitForm form: RealestateSoldStateQuestionFormSubmit)
}

public class RealestateSoldStateView: UIView {

    // MARK: - Public properties

    public weak var delegate: RealestateSoldStateViewDelegate?

    // MARK: - Private properties

    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)
    private lazy var questionFormView = QuestionFormContainerView(delegate: self, withAutoLayout: true)
    private lazy var agentProfileView = AgentProfileView(withAutoLayout: true)

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        stackView.addArrangedSubviews([questionFormView, agentProfileView])
        addSubview(stackView)
        stackView.fillInSuperview(insets: UIEdgeInsets(top: 0, left: .spacingM, bottom: 0, right: -.spacingM))
    }

    // MARK: - Public methods

    public func configure(with viewModel: RealestateSoldStateModel, remoteImageViewDataSource: RemoteImageViewDataSource) {
        questionFormView.configure(with: viewModel.questionForm)
        agentProfileView.configure(with: viewModel.agentProfile, remoteImageViewDataSource: remoteImageViewDataSource)
    }
}

// MARK: - QuestionFormContainerViewDelegate

extension RealestateSoldStateView: QuestionFormContainerViewDelegate {
    func questionFormContainerView(_ view: QuestionFormContainerView, didSubmitForm form: RealestateSoldStateQuestionFormSubmit) {
        delegate?.realestateSoldStateView(self, didSubmitForm: form)
    }
}
