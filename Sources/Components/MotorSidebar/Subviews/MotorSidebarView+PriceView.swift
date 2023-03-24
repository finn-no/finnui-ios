import FinniversKit

extension MotorSidebarView {
    class PriceView: UIView {

        // MARK: - Private properties

        private lazy var stackView = UIStackView(axis: .vertical, spacing: 0, withAutoLayout: true)
        private lazy var titleLabel = Label(style: .captionStrong, numberOfLines: 0, textColor: .textSecondary, withAutoLayout: true)
        private lazy var valueLabel = Label(style: .title1, numberOfLines: 0, withAutoLayout: true)

        // MARK: - Init

        init(price: ViewModel.Price) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            setup(price: price)
        }

        required init?(coder: NSCoder) { fatalError() }

        // MARK: - Setup

        private func setup(price: ViewModel.Price) {
            titleLabel.text = price.title
            valueLabel.text = price.value

            stackView.addArrangedSubviews([titleLabel, valueLabel])
            addSubview(stackView)
            stackView.fillInSuperview()
        }
    }
}
