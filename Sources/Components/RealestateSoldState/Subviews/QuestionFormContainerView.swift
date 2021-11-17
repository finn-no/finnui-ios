import UIKit
import FinniversKit

protocol QuestionFormContainerViewDelegate: AnyObject {
    func questionFormContainerView(_ view: QuestionFormContainerView, didSubmitForm form: RealestateSoldStateQuestionFormSubmit)
}

class QuestionFormContainerView: UIView {

    // MARK: - Private properties

    private let viewModel: QuestionFormViewModel
    private weak var delegate: QuestionFormContainerViewDelegate?
    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingL, withAutoLayout: true)
    private lazy var questionFormView = QuestionFormView(delegate: self, withAutoLayout: true)

    private lazy var userContactMethodView = UserContactInformationView(
        title: viewModel.contactMethodTitle,
        contactMethodEmail: viewModel.contactMethodEmail,
        contactMethodPhone: viewModel.contactMethodPhone,
        delegate: self,
        withAutoLayout: true
    )

    private lazy var dislamerLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.numberOfLines = 0
        label.textColor = .textSecondary
        return label
    }()

    private lazy var submitButton: Button = {
        let button = Button(style: .callToAction, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    init(viewModel: QuestionFormViewModel, delegate: QuestionFormContainerViewDelegate, withAutoLayout: Bool) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        stackView.addArrangedSubviews([questionFormView, userContactMethodView, dislamerLabel, submitButton])
        addSubview(stackView)
        stackView.fillInSuperview()

        questionFormView.configure(with: viewModel.questionsTitle, questions: viewModel.questions)

        dislamerLabel.text = viewModel.submitDisclaimer
        submitButton.setTitle(viewModel.submitButtonTitle, for: .normal)
    }

    // MARK: - Private methods

    private func updateSubmitButtonState() {
        submitButton.isEnabled = userContactMethodView.isInputValid && questionFormView.hasSelectedQuestions
    }

    // MARK: - Actions

    @objc private func submitButtonTapped() {
        guard
            let contactMethod = userContactMethodView.selectedContactMethod,
            let contactMethodValue = contactMethod.value
        else { return }

        let formSubmit = RealestateSoldStateQuestionFormSubmit(
            contactMethodIdentifier: contactMethod.identifier,
            contactMethodValue: contactMethodValue,
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
        print("✒️ Did toggle textView")
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
