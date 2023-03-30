import FinniversKit

extension MotorSidebarView {
    class SectionHeaderView: UIView {

        // MARK: - Private properties

        private let shouldChangeLayoutWhenCompact: Bool
        private lazy var titleLabel = Label(style: .body, numberOfLines: 0, withAutoLayout: true)

        private lazy var stackView: UIStackView = {
            let view = UIStackView(axis: .horizontal, spacing: .spacingS, alignment: .center, withAutoLayout: true)
            view.isLayoutMarginsRelativeArrangement = true
            return view
        }()

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

        init(
            title: String,
            icon: UIImage,
            shouldChangeLayoutWhenCompact: Bool,
            isExpandable: Bool,
            isExpanded: Bool
        ) {
            self.shouldChangeLayoutWhenCompact = shouldChangeLayoutWhenCompact
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            setup(title: title, icon: icon, isExpandable: isExpandable, isExpanded: isExpanded)
        }

        required init?(coder: NSCoder) { fatalError() }

        // MARK: - Setup

        private func setup(title: String, icon: UIImage, isExpandable: Bool, isExpanded: Bool) {
            isAccessibilityElement = true
            accessibilityTraits = .header
            accessibilityLabel = title

            titleLabel.text = title
            iconImageView.image = icon.withRenderingMode(.alwaysTemplate)

            stackView.addArrangedSubviews([iconImageView, titleLabel, UIView()])

            if isExpandable {
                stackView.addArrangedSubview(chevronImageView)
            }

            addSubview(stackView)
            stackView.fillInSuperview()

            NSLayoutConstraint.activate([
                iconImageView.widthAnchor.constraint(equalToConstant: .spacingL),
                iconImageView.heightAnchor.constraint(equalToConstant: .spacingL),
                chevronImageView.widthAnchor.constraint(equalToConstant: .spacingL),
                chevronImageView.heightAnchor.constraint(equalToConstant: .spacingL),
            ])

            configurePresentation()
            updateExpandedState(isExpanded: isExpanded)
        }

        // MARK: - Internal methods

        func updateExpandedState(isExpanded: Bool) {
            let transform = CGAffineTransform.identity
            if isExpanded {
                chevronImageView.transform = transform
            } else {
                chevronImageView.transform = transform.rotated(by: .pi * 180)
                chevronImageView.transform = transform.rotated(by: .pi * -1)
            }
        }

        // MARK: - Overrides

        public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)

            if traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass {
                configurePresentation()
            }
        }

        // MARK: - Private methods

        private func configurePresentation() {
            let regularInsets = NSDirectionalEdgeInsets(all: .spacingM)
            switch traitCollection.horizontalSizeClass {
            case .regular:
                stackView.directionalLayoutMargins = regularInsets
            default:
                if shouldChangeLayoutWhenCompact {
                    stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(vertical: .spacingM, horizontal: 0)
                } else {
                    stackView.directionalLayoutMargins = regularInsets
                }
            }
        }
    }
}
