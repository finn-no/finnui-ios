import FinniversKit

public final class FiksFerdigInfoView: UIScrollView {
    let viewModel: FiksFerdigInfoViewModel

    private lazy var containerView = UIStackView(axis: .vertical, withAutoLayout: true)

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
        backgroundColor = .bgPrimary
        addSubview(containerView)

        var subViews: [UIView] = [
            serviceInfoView,
            shippingInfoView,
            safePaymentInfoView
        ].compactMap { $0 }

        var separators: [UIView] = []
        if subViews.count > 1 {
            let separatorCount = subViews.count - 1
            separators = (0..<separatorCount).map { _ in createSeparatorView() }
            subViews = zip(subViews, separators).flatMap { [$0.0, $0.1] } + subViews.suffix(1)
        }

        containerView.addArrangedSubviews(subViews)

        var constraints: [NSLayoutConstraint] = [
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor, constant: -.spacingM * 2),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        constraints += separators.flatMap { separator in
            return [
                separator.widthAnchor.constraint(equalTo: contentLayoutGuide.widthAnchor),
                separator.heightAnchor.constraint(equalToConstant: 1)
            ]
        }
        NSLayoutConstraint.activate(constraints)
    }

    private func createSeparatorView() -> UIView {
        let separatorView = UIView(withAutoLayout: true)
        separatorView.backgroundColor = .borderDefault
        return separatorView
    }
}
