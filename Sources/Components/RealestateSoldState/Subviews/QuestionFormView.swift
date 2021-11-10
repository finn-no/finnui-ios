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
        questions.filterProvided.contains(where: { $0.isSelected }) ||
        ((questions.firstUserFreetext?.isSelected ?? false) && !(questions.firstUserFreetext?.value?.isEmpty ?? true))
    }

    // MARK: - Private properties

    private weak var delegate: QuestionFormViewDelegate?
    private var questions = [RealestateSoldStateQuestionModel]()
    private lazy var questionsStackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var textView: TextView = {
        let textView = TextView(withAutoLayout: true)
        textView.delegate = self
        textView.isScrollEnabled = false
        return textView
    }()

    // MARK: - Init

    init(delegate: QuestionFormViewDelegate, withAutoLayout: Bool) {
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

            questionsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingM),
            questionsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            questionsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            questionsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Internal methods

    func configure(with title: String, questions: [RealestateSoldStateQuestionModel]) {
        self.questions = questions

        titleLabel.text = title
        questionsStackView.removeArrangedSubviews()

        let questionItemViews = questions.filterProvided.map { question -> QuestionItemView in
            QuestionItemView(question: question, delegate: self)
        }
        questionsStackView.addArrangedSubviews(questionItemViews)

        if let userFreetextQuestion = questions.firstUserFreetext {
            let questionItemView = QuestionItemView(question: userFreetextQuestion, delegate: self)
            questionsStackView.addArrangedSubviews([questionItemView, textView])

            textView.isHidden = !userFreetextQuestion.isSelected
            textView.text = userFreetextQuestion.value ?? ""
        }
    }
}

// MARK: - QuestionItemViewDelegate

extension QuestionFormView: QuestionItemViewDelegate {
    func questionItemViewWasSelected(_ view: QuestionItemView) {
        view.question.isSelected.toggle()
        view.updateView()
        delegate?.questionFormViewDidToggleQuestion(self)

        if case .userFreetext = view.question.kind {
            textView.isHidden = !view.question.isSelected
            delegate?.questionFormViewDidToggleTextView(self)
        }
    }
}

// MARK: - TextViewDelegate

extension QuestionFormView: TextViewDelegate {
    public func textViewDidChange(_ textView: TextView) {
        guard let question = questions.firstUserFreetext else { return }
        question.value = textView.text
        delegate?.questionFormViewDidUpdateFreeTextQuestion(self)
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
