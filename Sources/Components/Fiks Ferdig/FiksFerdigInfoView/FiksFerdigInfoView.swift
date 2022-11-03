import FinniversKit

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

        var subViews: [UIView] = [
            createSeparatorView(),
            serviceInfoView,
            createSeparatorView()
        ]

        if let shippingInfoView = shippingInfoView {
            subViews.append(contentsOf: [
                shippingInfoView,
                createSeparatorView(),
            ])
        }

        subViews.append(contentsOf: [
            safePaymentInfoView,
            createSeparatorView()
        ])

        containerView.addArrangedSubviews(subViews)
    }

    private func createSeparatorView() -> UIView {
        let separatorView = UIView(withAutoLayout: true)
        separatorView.backgroundColor = .borderDefault
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return separatorView
    }
}
