import UIKit
import FinniversKit

protocol QuestionFormViewDelegate: AnyObject {
    func questionFormView(_ view: QuestionFormView, didSelectQuestion question: String)
}

class QuestionFormView: UIView {

    // MARK: - Internal properties

    weak var delegate: QuestionFormViewDelegate?

    // MARK: - Private properties

    private lazy var questionsStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        titleLabel.text = "Yo?"
        addSubview(titleLabel)
        addSubview(questionsStackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            /// Heyo
            questionsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingM),
            questionsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            questionsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            questionsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Internal methods

    func configure(with questions: [String], questionsAlreadySelected: [String]) {
        questionsStackView.removeArrangedSubviews()

        let questionItemViews = questions.map { question -> QuestionItemView in
            let isSelected = questionsAlreadySelected.contains(question)
            return QuestionItemView(question: question, isSelected: isSelected, delegate: self)
        }
        questionsStackView.addArrangedSubviews(questionItemViews)
    }
}

// MARK: - QuestionItemViewDelegate

extension QuestionFormView: QuestionItemViewDelegate {
    func questionItemViewWasSelected(_ view: QuestionItemView) {
        view.toggleSelection()
        delegate?.questionFormView(self, didSelectQuestion: view.question)
    }
}
