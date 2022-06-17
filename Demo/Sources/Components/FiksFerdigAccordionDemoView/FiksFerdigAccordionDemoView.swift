import FinniversKit
import FinnUI

final class FiksFerdigAccordionDemoView: UIView {
    var viewModel: FiksFerdigAccordionViewModel
    let accordionView: FiksFerdigAccordionView!

    override init(frame: CGRect) {
        let headerViewModel = TJTAccordionViewModel(
            title: "Fiks ferdig",
            icon: UIImage(systemName: "shippingbox")!,
            isExpanded: true)
        let timelineItems = [
            TimeLineItem(title: "Betal med Vipps eller kort"),
            TimeLineItem(title: "Varen leveres hjem til deg"),
            TimeLineItem(title: "Du har 24 timer til å sjekke varen"),
        ]
        self.viewModel = FiksFerdigAccordionViewModel(
            headerViewModel: headerViewModel,
            message: "Enkel betaling og frakt gjennom FINN",
            timeLineItems: timelineItems,
            readMoreTitle: "Les mer om Fiks ferdig"
        )
        self.accordionView = FiksFerdigAccordionView(
            viewModel: viewModel,
            withAutoLayout: true
        )

        super.init(frame: frame)

        viewModel.delegate = self
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(accordionView)

        NSLayoutConstraint.activate([
            accordionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingM),
            accordionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingM),
            accordionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingM)
        ])

        accordionView.layoutIfNeeded()
    }
}

extension FiksFerdigAccordionDemoView: FiksFerdigAccordionViewModelDelegate {
    func didTapReadMore() {
        print("🎉 read more")
    }
}
