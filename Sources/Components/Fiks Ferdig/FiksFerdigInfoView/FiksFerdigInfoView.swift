import FinniversKit

public final class FiksFerdigInfoView: UIView {
    private let viewModel: FiksFerdigInfoViewModel

    private let containerView = UIStackView(axis: .vertical, withAutoLayout: true)
    private lazy var serviceInfoView = FiksFerdigServiceInfoView(
        viewModel: viewModel.serviceInfoViewModel,
        withAutoLayout: true
    )

    private lazy var shippingInfoView: FiksFerdigShippingInfoView? = {
        guard let shippingInfoViewModel = viewModel.shippingInfoViewModel else {
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

        var subViews: [UIView] = [
            serviceInfoView,
            shippingInfoView,
            safePaymentInfoView
        ].compactMap { $0 }

        if subViews.count > 1 {
            let separatorCount = subViews.count - 1
            let separators: [UIView] = (0..<separatorCount).map { _ in createSeparatorView() }
            subViews = zip(subViews, separators).flatMap { [$0.0, $0.1] } + subViews.suffix(1)
        }

        containerView.addArrangedSubviews(subViews)
    }

    private func createSeparatorView() -> UIView {
        let separatorView = UIView(withAutoLayout: true)
        separatorView.backgroundColor = .borderDefault
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return separatorView
    }
}
