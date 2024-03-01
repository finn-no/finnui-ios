import UIKit
import FinniversKit

protocol QuestionFormViewDelegate: AnyObject {
    func questionFormViewDidToggleQuestion(_ view: QuestionFormView)
    func questionFormViewDidUpdateFreeTextQuestion(_ view: QuestionFormView)
    func questionFormViewDidToggleTextView(_ view: QuestionFormView)
}

class QuestionFormView: UIView {

    // MARK: - Internal methods

    var hasSelectedQuestions: Bool {
        !selectedQuestions.isEmpty
    }

    var selectedQuestions: [RealestateSoldStateQuestionModel] {
        questions.filter(\.isSelected)
    }

    // MARK: - Private properties

    private weak var delegate: QuestionFormViewDelegate?
    private let viewModel: QuestionFormViewModel
    private var questions = [RealestateSoldStateQuestionModel]()
    private var freeTextCharacterCountSuffix: String?
    private lazy var questionsStackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var textView: TextView = {
        let textView = TextView(withAutoLayout: true)
        textView.delegate = self
        textView.isScrollEnabled = true
        textView.configure(textViewBackgroundColor: .bgPrimary)
        textView.configure(shouldHideUnderLine: true)
        textView.layer.cornerRadius = 4
        textView.layer.borderWidth = 1
        return textView
    }()

    private lazy var freeTextCharacterCountLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var freeTextDisclaimerLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    init(viewModel: QuestionFormViewModel, delegate: QuestionFormViewDelegate, withAutoLayout: Bool) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(titleLabel)
        addSubview(questionsStackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            textView.heightAnchor.constraint(equalToConstant: 120),

            questionsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingM),
            questionsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            questionsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            questionsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])


        titleLabel.text = viewModel.questionsTitle
        freeTextDisclaimerLabel.text = viewModel.userFreeTextDisclaimer
        questions = viewModel.questions

        let questionItemViews = questions.filterProvided.map { question -> QuestionItemView in
            QuestionItemView(question: question, delegate: self)
        }
        questionsStackView.addArrangedSubviews(questionItemViews)

        if let userFreetextQuestion = questions.firstUserFreetext {
            let questionItemView = QuestionItemView(question: userFreetextQuestion, delegate: self)
            questionsStackView.addArrangedSubviews([questionItemView, textView, freeTextCharacterCountLabel, freeTextDisclaimerLabel])
            questionsStackView.setCustomSpacing(.spacingXS, after: freeTextCharacterCountLabel)

            [textView, freeTextCharacterCountLabel, freeTextDisclaimerLabel].forEach { $0.isHidden = !userFreetextQuestion.isSelected }

            textView.text = userFreetextQuestion.value ?? ""
            updateCharacterCountLabel()
        }
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        textView.layer.borderColor = UIColor.borderDefault.cgColor
    }

    // MARK: - Private methods

    private func updateCharacterCountLabel() {
        let userFreeTextCount = (textView.text ?? "").count
        freeTextCharacterCountLabel.text = "\(userFreeTextCount) / \(viewModel.userFreeTextCharacterLimit) \(viewModel.userFreeTextCounterSuffix)"
    }
}

// MARK: - QuestionItemViewDelegate

extension QuestionFormView: QuestionItemViewDelegate {
    func questionItemViewWasSelected(_ view: QuestionItemView) {
        view.question.isSelected.toggle()
        view.updateView()
        delegate?.questionFormViewDidToggleQuestion(self)

        if case .userFreetext = view.question.kind {
            [textView, freeTextCharacterCountLabel, freeTextDisclaimerLabel].forEach { $0.isHidden = !view.question.isSelected }
            delegate?.questionFormViewDidToggleTextView(self)
        }
    }
}

// MARK: - TextViewDelegate

extension QuestionFormView: TextViewDelegate {
    public func textViewDidChange(_ textView: TextView) {
        guard let question = questions.firstUserFreetext else { return }
        question.value = textView.text
        updateCharacterCountLabel()
        delegate?.questionFormViewDidUpdateFreeTextQuestion(self)
    }

    public func textView(_ textView: TextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard
            let currentText = textView.text,
            let stringRange = Range(range, in: currentText)
        else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= viewModel.userFreeTextCharacterLimit
    }
}


// MARK: - Private extensions

private extension Array where Element == RealestateSoldStateQuestionModel {
    var filterProvided: [RealestateSoldStateQuestionModel] {
        filter { $0.kind == .provided }
    }

    var firstUserFreetext: RealestateSoldStateQuestionModel? {
        first { $0.kind == .userFreetext }
    }
}
