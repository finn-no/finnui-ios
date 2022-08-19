import FinnUI
import UIKit

final class FiksFerdigInfoDemoView: UIView {
    var sidebar: FiksFerdigInfoView

    override init(frame: CGRect) {
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
            provider: .heltHjem,
            providerName: "Helthjem",
            message: "Du betaler 60 kr for frakten",
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

        let viewModel = FiksFerdigInfoViewModel(
            serviceInfoViewModel: serviceInfoViewModel,
            shippingInfoViewModel: shippingInfoViewModel,
            safePaymentInfoViewModel: safePaymentInfoViewModel
        )

        sidebar = FiksFerdigInfoView(viewModel: viewModel, withAutoLayout: true)

        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(sidebar)

        NSLayoutConstraint.activate([
            sidebar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            sidebar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingM),
            sidebar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
