import UIKit
import FinniversKit

protocol UserContactMethodSelectionViewDelegate: AnyObject {
    func userContactMethodSelectionViewWasSelected(_ view: UserContactMethodSelectionView)
}

class UserContactMethodSelectionView: UIView {

    // MARK: - Private properties

    let viewModel: UserContactMethodSelectionModel
    private let styling: RealestateSoldStateModel.Styling
    private weak var delegate: UserContactMethodSelectionViewDelegate?
    private lazy var radioButton = AnimatedRadioButtonView(frame: .zero)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: .spacingXS, withAutoLayout: true)
        stackView.alignment = .center
        stackView.addArrangedSubviews([radioButton, titleLabel])
        return stackView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    init(viewModel: UserContactMethodSelectionModel, styling: RealestateSoldStateModel.Styling, delegate: UserContactMethodSelectionViewDelegate) {
        self.viewModel = viewModel
        self.styling = styling
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        radioButton.isHighlighted = viewModel.isSelected
        titleLabel.text = viewModel.name
        titleLabel.textColor = styling.textColor

        addSubview(stackView)
        stackView.fillInSuperview()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    // MARK: - Internal methods

    func updateView() {
        radioButton.animateSelection(selected: !radioButton.isHighlighted)
    }

    // MARK: - Actions

    @objc private func handleTap() {
        guard !radioButton.isHighlighted else { return }
        delegate?.userContactMethodSelectionViewWasSelected(self)
    }
}

