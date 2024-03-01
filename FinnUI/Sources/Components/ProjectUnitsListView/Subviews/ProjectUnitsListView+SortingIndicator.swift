import FinniversKit

extension ProjectUnitsListView {
    class SortingIndicator: UIView {

        // MARK: - Private properties

        private lazy var sortingValueLabel = Label(style: .bodyStrong, textColor: .textAction, withAutoLayout: true)

        private lazy var stackView: UIStackView = {
            let stackView = UIStackView(axis: .horizontal, spacing: .spacingXS, withAutoLayout: true)
            stackView.alignment = .center
            stackView.distribution = .fill
            return stackView
        }()

        private lazy var arrowImageView: UIImageView = {
            let imageView = UIImageView(withAutoLayout: true)
            imageView.image = UIImage(named: .chevronDown)
            imageView.tintColor = .textSecondary
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()

        // MARK: - Init

        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }

        required init?(coder: NSCoder) { fatalError() }

        // MARK: - Setup

        private func setup() {
            stackView.addArrangedSubviews([sortingValueLabel, arrowImageView])
            addSubview(stackView)
            stackView.fillInSuperview()
        }

        // MARK: - Internal methods

        func configure(with title: String) {
            sortingValueLabel.text = title
        }
    }
}
