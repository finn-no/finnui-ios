import UIKit
import FinniversKit

protocol QuestionItemViewDelegate: AnyObject {
    func questionItemViewWasSelected(_ view: QuestionItemView)
}

class QuestionItemView: UIView {

    // MARK: - Internal properties

    let question: String

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

    init(question: String, isSelected: Bool, delegate: QuestionItemViewDelegate) {
        self.question = question
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setup(question: question, isSelected: isSelected)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup(question: String, isSelected: Bool) {
        questionLabel.text = question
        checkbox.isHighlighted = isSelected

        addSubview(stackView)
        stackView.addArrangedSubviews([checkbox, questionLabel])
        stackView.fillInSuperview()

        NSLayoutConstraint.activate([
            checkbox.widthAnchor.constraint(equalToConstant: 24),
            checkbox.heightAnchor.constraint(equalToConstant: 24)
        ])

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    // MARK: - Internal methods

    func toggleSelection() {
        checkbox.isHighlighted.toggle()
    }

    // MARK: - Actions

    @objc private func handleTap() {
        delegate?.questionItemViewWasSelected(self)
    }
}

