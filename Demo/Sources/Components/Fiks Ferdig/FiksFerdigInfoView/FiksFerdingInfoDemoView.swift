import FinnUI
import UIKit

final class FiksFerdigInfoDemoView: UIView, Tweakable {
    var sidebar: FiksFerdigInfoView!

    let serviceInfoViewModel = FiksFerdigServiceInfoViewModel(
        headerTitle: "Fiks ferdig",
        message: "Enkel betaling og frakt gjennom FINN",
        timeLineItems: [
            TimeLineItem(title: "Betal med Vipps eller kort"),
            TimeLineItem(title: "Varen leveres hjem til deg"),
            TimeLineItem(title: "Du har 24 timer til å sjekke varen"),
        ],
        readMoreTitle: "Les mer om Fiks ferdig",
        readMoreURL: URL(string: "https://finn.no")!,
        isExpanded: true
    )

    let shippingInfoViewModel = FiksFerdigShippingInfoViewModel(
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

    let safePaymentInfoViewModel = FiksFerdigSafePaymentInfoViewModel(
        headerTitle: "Trygg betaling",
        timeLineItems: [
            TimeLineItem(title: "Betal med Vipps eller kort"),
            TimeLineItem(title: "Varen leveres hjem til deg"),
            TimeLineItem(title: "Du har 24 timer til å sjekke varen")
        ],
        isExpanded: true
    )

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Full info with Helthjem") { [unowned self] in
            let viewModel = FiksFerdigInfoViewModel(
                serviceInfoViewModel: serviceInfoViewModel,
                shippingInfoViewModel: shippingInfoViewModel,
                safePaymentInfoViewModel: safePaymentInfoViewModel
            )
            setup(with: viewModel)
        },
        TweakingOption(title: "Missing shipping info") { [unowned self] in
            let viewModel = FiksFerdigInfoViewModel(
                serviceInfoViewModel: serviceInfoViewModel,
                shippingInfoViewModel: nil,
                safePaymentInfoViewModel: safePaymentInfoViewModel
            )
            setup(with: viewModel)
        }
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        tweakingOptions.first?.action!()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup(with viewModel: FiksFerdigInfoViewModel) {
        if sidebar != nil {
            sidebar.removeFromSuperview()
        }

        sidebar = FiksFerdigInfoView(viewModel: viewModel, withAutoLayout: true)
        addSubview(sidebar)

        NSLayoutConstraint.activate([
            sidebar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            sidebar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingM),
            sidebar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
