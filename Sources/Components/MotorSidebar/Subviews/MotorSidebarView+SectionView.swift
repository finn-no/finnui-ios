import FinniversKit

extension MotorSidebarView {
    class SectionView: UIView {

        // MARK: - Private properties

        private var headerView: SectionHeaderView?
        private var ribbonView: RibbonView?
        private lazy var contentStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        private lazy var bodyStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        private lazy var bulletPointsStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        private lazy var buttonStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)

        // MARK: - Init

        init(section: ViewModel.Section) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            setup(section: section)
        }

        required init?(coder: NSCoder) { fatalError() }

        // MARK: - Setup

        private func setup(section: ViewModel.Section) {
            if let ribbon = section.ribbon {
                let ribbonView = RibbonView(ribbon: ribbon)
                self.ribbonView = ribbonView

                addSubview(ribbonView)
                NSLayoutConstraint.activate([
                    ribbonView.topAnchor.constraint(equalTo: topAnchor),
                    ribbonView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    ribbonView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
                    ribbonView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
                ])
            }

            if let header = section.header {
                let headerView = SectionHeaderView(
                    title: header.title,
                    icon: header.icon,
                    isExpandable: section.isExpandable,
                    isExpanded: section.isExpanded ?? true
                )
                self.headerView = headerView

                addSubview(headerView)
                NSLayoutConstraint.activate([
                    headerView.topAnchor.constraint(equalTo: ribbonView?.bottomAnchor ?? topAnchor),
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

            addSubview(contentStackView)
            NSLayoutConstraint.activate([
                contentStackView.topAnchor.constraint(
                    equalTo: ribbonView?.bottomAnchor ?? headerView?.bottomAnchor ?? topAnchor,
                    constant: ribbonView != nil ? 0 : .spacingS
                ),
                contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
                contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
                contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingS),
            ])
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
