import FinniversKit
@testable import FinnUI

final class FiksFerdigShippingInfoDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Multi-lined text with Multiple Providers") { [unowned self] in
            let viewModel = FiksFerdigShippingInfoViewModel(
                headerTitle: "Varen sendes med",
                providers: [
                .init(
                    provider: .postnord,
                    providerName: "Postnord",
                    message: "Du betaler 60 kr for frakten"
                ),
                .init(
                    provider: .posten,
                    providerName: "Posten",
                    message: "Du betaler 60 kr for frakten"
                ),
                .init(
                    provider: .heltHjem,
                    providerName: "Helthjem idjaisj daj id aisdijasid as asduhsahdahsd daijsidj asja",
                    message: "Du betaler 60 kr for frakten sdiasiu djiajs idj asij diasj idj asij dias"
                )
                ],
                noProviderText: "Du kan velge hvilken leverandør pakken skal sendes med når du legger inn en forespørsel.",
                isExpanded: true
            )
            setup(with: viewModel)
        },
        TweakingOption(title: "No Providers") { [unowned self] in
            let viewModel = FiksFerdigShippingInfoViewModel(
                headerTitle: "Varen sendes med",
                providers: [],
                noProviderText: "Du kan velge hvilken leverandør pakken skal sendes med når du legger inn en forespørsel.",
                isExpanded: true
            )
            setup(with: viewModel)
        }
    ]

    var viewModel: FiksFerdigShippingInfoViewModel!
    var accordionView: FiksFerdigShippingInfoView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        tweakingOptions.first?.action!()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup(with viewModel: FiksFerdigShippingInfoViewModel) {
        accordionView?.removeFromSuperview()

        let accordionView = FiksFerdigShippingInfoView(
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

        self.viewModel = viewModel
        self.accordionView = accordionView
        viewModel.headerViewModel.delegate = self
    }
}

extension FiksFerdigShippingInfoDemoView: FiksFerdigAccordionViewModelDelegate {
    func didChangeExpandedState(isExpanded: Bool) {
        print("didChangeExpandedState: \(isExpanded)")
    }
}
