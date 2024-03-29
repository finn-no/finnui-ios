import UIKit
import FinniversKit

protocol QuestionFormContainerViewDelegate: AnyObject {
    func questionFormContainerView(_ view: QuestionFormContainerView, didSubmitForm form: RealestateSoldStateQuestionFormSubmit)
    func questionFormContainerViewDidSubmitFormWithoutContactInformation(
        _ view: QuestionFormContainerView,
        questionModels: [RealestateSoldStateQuestionModel]
    )
    func questionFormContainerViewDidToggleTextView(_ view: QuestionFormContainerView)
}

class QuestionFormContainerView: UIView {

    // MARK: - Private properties

    private let viewModel: QuestionFormViewModel
    private let style: RealestateSoldStateModel.Style
    private var userContactMethodView: UserContactInformationView?
    private weak var delegate: QuestionFormContainerViewDelegate?
    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingL, withAutoLayout: true)
    private lazy var questionFormView = QuestionFormView(viewModel: viewModel, delegate: self, withAutoLayout: true)

    private lazy var disclaimerLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var submitButton: Button = {
        let button = Button(style: .callToAction.override(using: style.actionButtonStyle), size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    init(
        viewModel: QuestionFormViewModel,
        style: RealestateSoldStateModel.Style,
        delegate: QuestionFormContainerViewDelegate,
        withAutoLayout: Bool
    ) {
        self.viewModel = viewModel
        self.style = style
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        if let contactMethod = viewModel.contactMethod {
            let userContactMethodView = UserContactInformationView(
                contactMethod: contactMethod,
                userContactName: viewModel.userContactName,
                delegate: self,
                withAutoLayout: true
            )
            self.userContactMethodView = userContactMethodView
            stackView.addArrangedSubviews([questionFormView, userContactMethodView, disclaimerLabel, submitButton])
        } else {
            stackView.addArrangedSubviews([questionFormView, disclaimerLabel, submitButton])
        }

        addSubview(stackView)
        stackView.fillInSuperview()

        disclaimerLabel.text = viewModel.submitDisclaimer
        submitButton.setTitle(viewModel.submitButtonTitle, for: .normal)
        updateSubmitButtonState()
    }

    // MARK: - Private methods

    private func updateSubmitButtonState() {
        submitButton.isEnabled = (userContactMethodView?.isInputValid ?? true) && questionFormView.hasSelectedQuestions
    }

    // MARK: - Actions

    @objc private func submitButtonTapped() {
        guard
            let userContactMethodView = userContactMethodView,
            let contactMethod = userContactMethodView.selectedContactMethod,
            let contactMethodValue = contactMethod.value
        else {
            delegate?.questionFormContainerViewDidSubmitFormWithoutContactInformation(self, questionModels: viewModel.questions)
            return
        }

        let formSubmit = RealestateSoldStateQuestionFormSubmit(
            contactMethodIdentifier: contactMethod.identifier,
            contactMethodValue: contactMethodValue,
            userContactName: userContactMethodView.enteredUserContactName,
            questions: questionFormView.selectedQuestions
        )

        delegate?.questionFormContainerView(self, didSubmitForm: formSubmit)
    }
}

// MARK: - QuestionFormViewDelegate

extension QuestionFormContainerView: QuestionFormViewDelegate {
    func questionFormViewDidToggleQuestion(_ view: QuestionFormView) {
        updateSubmitButtonState()
    }

    func questionFormViewDidUpdateFreeTextQuestion(_ view: QuestionFormView) {
        updateSubmitButtonState()
    }

    func questionFormViewDidToggleTextView(_ view: QuestionFormView) {
        delegate?.questionFormContainerViewDidToggleTextView(self)
    }
}

// MARK: - UserContactInformationViewDelegate

extension QuestionFormContainerView: UserContactInformationViewDelegate {
    func userContactInformationViewDidSwitchContactMethod(_ view: UserContactInformationView) {
        updateSubmitButtonState()
    }

    func userContactInformationViewDidUpdateTextField(_ view: UserContactInformationView) {
        updateSubmitButtonState()
    }
}
