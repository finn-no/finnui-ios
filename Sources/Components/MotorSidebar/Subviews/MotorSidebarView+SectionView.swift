import FinniversKit

extension MotorSidebarView {
    class SectionView: UIView {

        // MARK: - Private properties

        private var isExpanded: Bool
        private var topView: UIView?
        private lazy var contentStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        private lazy var bodyStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        private lazy var bulletPointsStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        private lazy var buttonStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        private lazy var contentLayoutGuide = UILayoutGuide()
        private lazy var bottomAnchorExpandedConstraint = bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor, constant: .spacingS)
        private lazy var bottomAnchorCollapsedConstraint = bottomAnchor.constraint(equalTo: contentLayoutGuide.topAnchor)

        // MARK: - Init

        init(section: ViewModel.Section) {
            isExpanded = section.isExpanded ?? true
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            setup(section: section)
        }

        required init?(coder: NSCoder) { fatalError() }

        // MARK: - Setup

        private func setup(section: ViewModel.Section) {
            clipsToBounds = true

            // We will only keep one view at the top. Either it'll have a ribbon, or it'll have a header.
            if let ribbon = section.ribbon {
                let ribbonView = RibbonView(ribbon: ribbon)
                topView = ribbonView

                addSubview(ribbonView)
                NSLayoutConstraint.activate([
                    ribbonView.topAnchor.constraint(equalTo: topAnchor),
                    ribbonView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    ribbonView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
                    ribbonView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
                ])
            } else if let header = section.header {
                let headerView = SectionHeaderView(
                    title: header.title,
                    icon: header.icon,
                    isExpandable: section.isExpandable,
                    isExpanded: section.isExpanded ?? true
                )
                headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(headerTapped)))
                topView = headerView

                addSubview(headerView)
                NSLayoutConstraint.activate([
                    headerView.topAnchor.constraint(equalTo: topAnchor),
                    headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    headerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
                    headerView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
                ])
            }

            if let price = section.price {
                let priceView = PriceView(price: price)
                contentStackView.addArrangedSubview(priceView)
            }

            if !section.content.isEmpty {
                let subviews = section.content.map { SectionBodyView(body: $0) }
                bodyStackView.addArrangedSubviews(subviews)
                contentStackView.addArrangedSubview(bodyStackView)
            }

            if !section.bulletPoints.isEmpty {
                let subviews = section.bulletPoints.map { BulletPointView(text: $0) }
                bulletPointsStackView.addArrangedSubviews(subviews)
                contentStackView.addArrangedSubview(bulletPointsStackView)
            }

            if !section.buttons.isEmpty {
                let buttons = section.buttons.map { Button.create(from: $0) }
                buttonStackView.addArrangedSubviews(buttons)
                contentStackView.addArrangedSubview(buttonStackView)
            }

            addLayoutGuide(contentLayoutGuide)
            addSubview(contentStackView)
            NSLayoutConstraint.activate([
                contentLayoutGuide.topAnchor.constraint(equalTo: topView?.bottomAnchor ?? topAnchor),
                contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
                contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

                contentStackView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor, constant: topView != nil ? 0 : .spacingS),
                contentStackView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
                contentStackView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
                contentStackView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor)
            ])
            updateStateConstraints()
        }

        // MARK: - Private methods

        private func updateStateConstraints() {
            if isExpanded {
                bottomAnchorCollapsedConstraint.isActive = false
                bottomAnchorExpandedConstraint.isActive = true
            } else {
                bottomAnchorExpandedConstraint.isActive = false
                bottomAnchorCollapsedConstraint.isActive = true
            }
            layoutIfNeeded()
        }

        // MARK: - Actions

        @objc private func headerTapped() {
            isExpanded.toggle()
            updateStateConstraints()
        }
    }
}

// MARK: - Private extension

private extension Button {
    static func create(from viewModel: MotorSidebarView.ViewModel.Button) -> Button {
        let button = Button(style: viewModel.kind.buttonStyle, size: .normal, withAutoLayout: true)
        button.setTitle(viewModel.text, for: .normal)
        return button
    }
}
