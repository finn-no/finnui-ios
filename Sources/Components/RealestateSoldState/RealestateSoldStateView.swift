import UIKit
import FinniversKit

public protocol RealestateSoldStateViewDelegate: AnyObject {}

public class RealestateSoldStateView: UIView {

    // MARK: - Public properties

    public weak var delegate: RealestateSoldStateViewDelegate?

    // MARK: - Private properties

    private lazy var questionFormView = QuestionFormContainerView(delegate: self, withAutoLayout: true)

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(questionFormView)
        questionFormView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(with viewModel: QuestionFormViewModel) {
        questionFormView.configure(with: viewModel)
    }
}

// MARK: - QuestionFormContainerViewDelegate

extension RealestateSoldStateView: QuestionFormContainerViewDelegate {}
