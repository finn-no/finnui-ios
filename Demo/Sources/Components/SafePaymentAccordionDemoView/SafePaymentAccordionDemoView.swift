import FinniversKit
@testable import FinnUI

final class SafePaymentAccordionDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Single lined text") { [unowned self] in
            let viewModel = SafePaymentAccordionViewModel(
                headerTitle: "Trygg betaling",
                timeLineItems: [
                    TimeLineItem(title: "Betal med Vipps eller kort"),
                    TimeLineItem(title: "Varen leveres hjem til deg"),
                    TimeLineItem(title: "Du har 24 timer til å sjekke varen")
                ],
                isExpanded: true
            )
            setup(with: viewModel)
        },
        TweakingOption(title: "Multilined text") { [unowned self] in
            let viewModel = SafePaymentAccordionViewModel(
                headerTitle: "Trygg betaling",
                timeLineItems: [
                    TimeLineItem(title: "Betal med Vipps eller kort Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
                    TimeLineItem(title: "Varen leveres hjem til deg"),
                    TimeLineItem(title: "Du har 24 timer til å sjekke varen Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor")
                ],
                isExpanded: true
            )
            setup(with: viewModel)
        }
    ]

    var accordionView: SafePaymentAccordionView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        tweakingOptions.first?.action!()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup(with viewModel: SafePaymentAccordionViewModel) {
        accordionView?.removeFromSuperview()

        let accordionView = SafePaymentAccordionView(
            viewModel: viewModel,
            withAutoLayout: true
        )

        addSubview(accordionView)

        NSLayoutConstraint.activate([
            accordionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingM),
            accordionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingM),
            accordionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingM)
        ])

        accordionView.layoutIfNeeded()

        self.accordionView = accordionView
        viewModel.delegate = self
    }
}

extension SafePaymentAccordionDemoView: SafePaymentAccordionViewModelDelegate {
    func didChangeExpandedState(isExpanded: Bool) {
        print("didChangeExpandedState: \(isExpanded)")
    }
}
