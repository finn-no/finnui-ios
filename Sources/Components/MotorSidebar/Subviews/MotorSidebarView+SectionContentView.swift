import FinniversKit

protocol MotorSidebarSectionContentViewDelegate: AnyObject {
    func motorSidebarSectionContentView(
        _ sectionView: MotorSidebarView.SectionContentView,
        didSelectButton viewModel: MotorSidebarView.ViewModel.Button
    )
}

extension MotorSidebarView {
    class SectionContentView: UIView {

        // MARK: - Internal properties

        override var directionalLayoutMargins: NSDirectionalEdgeInsets {
            get { contentStackView.directionalLayoutMargins }
            set { contentStackView.directionalLayoutMargins = newValue }
        }

        // MARK: - Private properties

        private weak var delegate: MotorSidebarSectionContentViewDelegate?
        private let section: ViewModel.Section
        private lazy var bodyStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        private lazy var bulletPointsStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        private lazy var buttonStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)

        private lazy var contentStackView: UIStackView = {
            let view = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
            view.isLayoutMarginsRelativeArrangement = true
            return view
        }()

        // MARK: - Init

        init(
            section: ViewModel.Section,
            delegate: MotorSidebarSectionContentViewDelegate
        ) {
            self.section = section
            self.delegate = delegate
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            setup()
        }

        required init?(coder: NSCoder) { fatalError() }

        // MARK: - Setup

        private func setup() {
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
                let buttons = section.buttons.map(Button.create(from:))
                buttons.forEach { $0.addTarget(self, action: #selector(buttonSelected(button:)), for: .touchUpInside) }
                buttonStackView.addArrangedSubviews(buttons)
                contentStackView.addArrangedSubview(buttonStackView)
            }

            addSubview(contentStackView)
            contentStackView.fillInSuperview()
        }

        // MARK: - Actions

        @objc private func buttonSelected(button: UIButton) {
            guard
                let buttonIndex = buttonStackView.arrangedSubviews.firstIndex(of: button),
                let buttonViewModel = section.buttons[safe: buttonIndex]
            else { return }

            delegate?.motorSidebarSectionContentView(self, didSelectButton: buttonViewModel)
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
