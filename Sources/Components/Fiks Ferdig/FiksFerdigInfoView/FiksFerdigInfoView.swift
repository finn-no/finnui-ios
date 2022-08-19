import FinniversKit

public protocol FiksFerdigInfoViewModelDelegate: AnyObject {
    func didChangeSidebarHeight()
}

public final class FiksFerdigInfoViewModel {
    public let serviceInfoViewModel: FiksFerdigServiceInfoViewModel
    public let shippingInfoViewModel: FiksFerdigShippingInfoViewModel?
    public let safePaymentInfoViewModel: FiksFerdigSafePaymentInfoViewModel

    public weak var delegate: FiksFerdigInfoViewModelDelegate?

    public init(serviceInfoViewModel: FiksFerdigServiceInfoViewModel, shippingInfoViewModel: FiksFerdigShippingInfoViewModel?, safePaymentInfoViewModel: FiksFerdigSafePaymentInfoViewModel) {
        self.serviceInfoViewModel = serviceInfoViewModel
        self.shippingInfoViewModel = shippingInfoViewModel
        self.safePaymentInfoViewModel = safePaymentInfoViewModel

        serviceInfoViewModel.headerViewModel.delegate = self
        shippingInfoViewModel?.headerViewModel.delegate = self
        safePaymentInfoViewModel.headerViewModel.delegate = self
    }
}

extension FiksFerdigInfoViewModel: FiksFerdigAccordionViewModelDelegate {
    public func didChangeExpandedState(isExpanded: Bool) {
        delegate?.didChangeSidebarHeight()
    }
}

public final class FiksFerdigInfoView: UIView {
    private let viewModel: FiksFerdigInfoViewModel

    private let containerView = UIStackView(axis: .vertical, withAutoLayout: true)
    private lazy var serviceInfoView = FiksFerdigServiceInfoView(
        viewModel: viewModel.serviceInfoViewModel,
        withAutoLayout: true
    )

    private lazy var shippingInfoView: FiksFerdigShippingInfoView? = {
        guard
            let shippingInfoViewModel = viewModel.shippingInfoViewModel
        else {
            return nil
        }

        return FiksFerdigShippingInfoView(
            viewModel: shippingInfoViewModel,
            withAutoLayout: true
        )
    }()

    private lazy var safePaymentInfoView = FiksFerdigSafePaymentInfoView(
        viewModel: viewModel.safePaymentInfoViewModel,
        withAutoLayout: true
    )

    public init(viewModel: FiksFerdigInfoViewModel, withAutoLayout: Bool = false) {
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

        let subViews: [UIView] = [
            createSeparatorView(),
            serviceInfoView,
            createSeparatorView(),
            shippingInfoView,
            createSeparatorView(),
            safePaymentInfoView,
            createSeparatorView()
        ].compactMap { $0 }
        containerView.addArrangedSubviews(subViews)
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
