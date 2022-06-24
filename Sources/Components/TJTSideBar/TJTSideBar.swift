import FinniversKit

public final class TJTSideBarViewModel {
    public let fiksFerdigViewModel: FiksFerdigAccordionViewModel
    public let shippingAlternativesViewModel: HeltHjemAccordionViewModel
    public let safePaymentViewModel: SafePaymentAccordionViewModel

    public init(fiksFerdigViewModel: FiksFerdigAccordionViewModel, shippingAlternativesViewModel: HeltHjemAccordionViewModel, safePaymentViewModel: SafePaymentAccordionViewModel) {
        self.fiksFerdigViewModel = fiksFerdigViewModel
        self.shippingAlternativesViewModel = shippingAlternativesViewModel
        self.safePaymentViewModel = safePaymentViewModel
    }
}

public final class TJTSideBar: UIView {
    private let viewModel: TJTSideBarViewModel

    private let containerView = UIStackView(axis: .vertical, withAutoLayout: true)
    private lazy var fiksFerdigAccordionView = FiksFerdigAccordionView(
        viewModel: viewModel.fiksFerdigViewModel,
        withAutoLayout: true
    )

    private lazy var heltHjemAccordionView = HeltHjemAccordionView(
        viewModel: viewModel.shippingAlternativesViewModel,
        withAutoLayout: true
    )

    private lazy var safePaymentViewModel = SafePaymentAccordionView(
        viewModel: viewModel.safePaymentViewModel,
        withAutoLayout: true
    )

    public init(viewModel: TJTSideBarViewModel, withAutoLayout: Bool = false) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(containerView)
        containerView.fillInSuperview()

        containerView.addArrangedSubviews([
            createSeparatorView(),
            fiksFerdigAccordionView,
            createSeparatorView(),
            heltHjemAccordionView,
            createSeparatorView(),
            safePaymentViewModel,
            createSeparatorView()
        ])
    }

    private func createSeparatorView() -> UIView {
        let separatorView = UIView(withAutoLayout: true)
        separatorView.backgroundColor = .separator
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return separatorView
    }
}

// MARK: - Private extensions

private extension UIColor {
    static var separator = dynamicColor(defaultColor: .sardine, darkModeColor: .darkSardine)
}
