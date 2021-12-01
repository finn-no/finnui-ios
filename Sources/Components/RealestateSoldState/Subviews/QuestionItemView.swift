import UIKit
import FinniversKit

protocol QuestionItemViewDelegate: AnyObject {
    func questionItemViewWasSelected(_ view: QuestionItemView)
}

class QuestionItemView: UIView {

    // MARK: - Internal properties

    let question: RealestateSoldStateQuestionModel

    // MARK: - Private properties

    private weak var delegate: QuestionItemViewDelegate?
    private lazy var checkbox = AnimatedCheckboxView(frame: .zero)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: .spacingXS, withAutoLayout: true)
        stackView.alignment = .center
        return stackView
    }()

    private lazy var questionLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    init(question: RealestateSoldStateQuestionModel, delegate: QuestionItemViewDelegate) {
        self.question = question
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        questionLabel.text = question.title
        checkbox.isHighlighted = question.isSelected

        addSubview(stackView)
        stackView.addArrangedSubviews([checkbox, questionLabel])
        stackView.fillInSuperview()

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    // MARK: - Internal methods

    func updateView() {
        if question.isSelected != checkbox.isHighlighted {
            checkbox.animateSelection(selected: question.isSelected)
        }
    }

    // MARK: - Actions

    @objc private func handleTap() {
        delegate?.questionItemViewWasSelected(self)
    }
}

