import FinnUI
import UIKit

final class TJTSideBarDemoView: UIView {
    var sidebar: TJTSideBar

    override init(frame: CGRect) {
        let fiksFerdigViewModel = FiksFerdigAccordionViewModel(
            headerTitle: "Fiks ferdig",
            message: "Enkel betaling og frakt gjennom FINN",
            timeLineItems: [
                TimeLineItem(title: "Betal med Vipps eller kort"),
                TimeLineItem(title: "Varen leveres hjem til deg"),
                TimeLineItem(title: "Du har 24 timer til å sjekke varen"),
            ],
            readMoreTitle: "Les mer om Fiks ferdig",
            isExpanded: true
        )

        let helthjemViewModel = HeltHjemAccordionViewModel(
            headerTitle: "Varen sendes med",
            providerName: "Helthjem",
            message: "Du betaler 60 kr for frakten",
            isExpanded: true
        )

        let safePaymentViewModel = SafePaymentAccordionViewModel(
            headerTitle: "Trygg betaling",
            timeLineItems: [
                TimeLineItem(title: "Betal med Vipps eller kort"),
                TimeLineItem(title: "Varen leveres hjem til deg"),
                TimeLineItem(title: "Du har 24 timer til å sjekke varen")
            ],
            isExpanded: true
        )

        let viewModel = TJTSideBarViewModel(
            fiksFerdigViewModel: fiksFerdigViewModel,
            shippingAlternativesViewModel: helthjemViewModel,
            safePaymentViewModel: safePaymentViewModel
        )

        sidebar = TJTSideBar(viewModel: viewModel, withAutoLayout: true)

        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(sidebar)

        NSLayoutConstraint.activate([
            sidebar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingM),
            sidebar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingM),
            sidebar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingM)
        ])
    }
}
