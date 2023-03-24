import FinniversKit

extension MotorSidebarView {
    class SectionHeaderView: UIView {

        // MARK: - Private properties

        private let isExpandable: Bool
        private var isExpanded: Bool
        private lazy var stackView = UIStackView(axis: .horizontal, spacing: .spacingS, alignment: .center, withAutoLayout: true)
        private lazy var titleLabel = Label(style: .body, numberOfLines: 0, withAutoLayout: true)

        private lazy var iconImageView: UIImageView = {
            let view = UIImageView(withAutoLayout: true)
            view.tintColor = .textPrimary
            view.contentMode = .scaleAspectFit
            return view
        }()

        private lazy var chevronImageView: UIView = {
            let view = UIImageView(withAutoLayout: true)
            view.image = UIImage(systemName: "chevron.up")
            view.tintColor = .textPrimary
            view.contentMode = .scaleAspectFit
            return view
        }()

        // MARK: - Init

        init(title: String, icon: UIImage, isExpandable: Bool, isExpanded: Bool) {
            self.isExpandable = isExpandable
            self.isExpanded = isExpanded
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            setup(title: title, icon: icon)
        }

        required init?(coder: NSCoder) { fatalError() }

        // MARK: - Setup

        private func setup(title: String, icon: UIImage) {
            titleLabel.text = title
            iconImageView.image = icon

            stackView.addArrangedSubviews([iconImageView, titleLabel, UIView()])

            if isExpandable {
                stackView.addArrangedSubview(chevronImageView)
            }

            addSubview(stackView)
            stackView.fillInSuperview(insets: UIEdgeInsets(top: .spacingS, leading: .spacingM, bottom: -.spacingS, trailing: -.spacingM))

            NSLayoutConstraint.activate([
                iconImageView.widthAnchor.constraint(equalToConstant: .spacingL),
                iconImageView.heightAnchor.constraint(equalToConstant: .spacingL),
                chevronImageView.widthAnchor.constraint(equalToConstant: .spacingL),
                chevronImageView.heightAnchor.constraint(equalToConstant: .spacingL),
            ])

            updateExpandedState()
        }

        // MARK: - Private methods

        private func updateExpandedState() {
            let transform = CGAffineTransform.identity
            if isExpanded {
                chevronImageView.transform = transform.rotated(by: .pi * 180)
                chevronImageView.transform = transform.rotated(by: .pi * -1)
            } else {
                chevronImageView.transform = transform
            }
        }
    }
}
