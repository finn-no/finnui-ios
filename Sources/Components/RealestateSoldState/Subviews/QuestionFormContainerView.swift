import UIKit
import FinniversKit

protocol QuestionFormContainerViewDelegate: AnyObject {
}

class QuestionFormContainerView: UIView {

    // MARK: - Private properties

    private weak var delegate: QuestionFormContainerViewDelegate?
    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingL, withAutoLayout: true)

    private lazy var questionFormView: QuestionFormView = {
        let view = QuestionFormView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private lazy var userContactMethodView: UserContactInformationView = {
        let view = UserContactInformationView(withAutoLayout: true)
        return view
    }()

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

    init(delegate: QuestionFormContainerViewDelegate, withAutoLayout: Bool) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        stackView.addArrangedSubviews([questionFormView, userContactMethodView, dislamerLabel, submitButton])
        addSubview(stackView)
        stackView.fillInSuperview(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: -16))
    }

    // MARK: - Internal methods

    func configure(with viewModel: QuestionFormViewModel) {
        questionFormView.configure(with: viewModel.questionsTitle, questions: viewModel.questions)
        userContactMethodView.configure(with: viewModel.contactMethodTitle, contactMethodModels: viewModel.contactMethodModels)

        dislamerLabel.text = viewModel.submitDisclaimer
        submitButton.setTitle(viewModel.submitButtonTitle, for: .normal)
    }

    // MARK: - Actions

    @objc private func submitButtonTapped() {
        // TODO: Handle button tap.
    }
}

// MARK: - QuestionFormViewDelegate

extension QuestionFormContainerView: QuestionFormViewDelegate {
    func questionFormViewDidToggleTextView(_ view: QuestionFormView) {
        print("✒️ Did toggle textView")
    }
}
