import FinniversKit

extension MotorSidebarView {
    class BulletPointView: UIView {

        // MARK: - Private properties

        private lazy var valueLabel = Label(style: .body, numberOfLines: 0, withAutoLayout: true)
        private lazy var stackView = UIStackView(axis: .horizontal, spacing: .spacingS, alignment: .center, withAutoLayout: true)

        private lazy var bulletImageView: UIImageView = {
            let image = UIImage(systemName: "circle.fill")
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .blueGray300
            return imageView
        }()

        // MARK: - Init

        init(text: String) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            setup(text: text)
        }

        required init?(coder: NSCoder) { fatalError() }

        // MARK: - Setup

        private func setup(text: String) {
            valueLabel.text = text

            stackView.addArrangedSubviews([bulletImageView, valueLabel])
            addSubview(stackView)
            stackView.fillInSuperview()

            NSLayoutConstraint.activate([
                bulletImageView.widthAnchor.constraint(equalToConstant: 12),
                bulletImageView.heightAnchor.constraint(equalToConstant: 12),
            ])
        }
    }
}
