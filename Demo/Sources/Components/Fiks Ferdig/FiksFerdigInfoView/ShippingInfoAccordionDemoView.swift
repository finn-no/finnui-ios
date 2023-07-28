import FinniversKit
@testable import FinnUI
import DemoKit

final class FiksFerdigShippingInfoDemoView: UIView {

    var viewModel: FiksFerdigShippingInfoViewModel!
    var accordionView: FiksFerdigShippingInfoView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(forTweakAt: 0)
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

// MARK: - TweakableDemo

extension FiksFerdigShippingInfoDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case multiLinedWithMultipleProviders
        case noProviders
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .multiLinedWithMultipleProviders:
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
        case .noProviders:
            let viewModel = FiksFerdigShippingInfoViewModel(
                headerTitle: "Varen sendes med",
                providers: [],
                noProviderText: "Du kan velge hvilken leverandør pakken skal sendes med når du legger inn en forespørsel.",
                isExpanded: true
            )
            setup(with: viewModel)
        }
    }
}

// MARK: - FiksFerdigAccordionViewModelDelegate

extension FiksFerdigShippingInfoDemoView: FiksFerdigAccordionViewModelDelegate {
    func didChangeExpandedState(isExpanded: Bool) {
        print("didChangeExpandedState: \(isExpanded)")
    }
}
