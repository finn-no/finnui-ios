import FinniversKit
import FinnUI

final class FiksFerdigServiceInfoDemoView: UIView {
    var viewModel: FiksFerdigServiceInfoViewModel
    let accordionView: FiksFerdigServiceInfoView

    override init(frame: CGRect) {
        let timelineItems = [
            TimeLineItem(title: "Betal med Vipps eller kort"),
            TimeLineItem(title: "Varen leveres hjem til deg"),
            TimeLineItem(title: "Du har 24 timer til å sjekke varen"),
        ]
        self.viewModel = FiksFerdigServiceInfoViewModel(
            headerTitle: "Fiks ferdig",
            message: "Enkel betaling og frakt gjennom FINN",
            timeLineItems: timelineItems,
            readMoreTitle: "Les mer om Fiks ferdig",
            readMoreURL: URL(string: "https://finn.no")!,
            isExpanded: true
        )
        self.accordionView = FiksFerdigServiceInfoView(
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

extension FiksFerdigServiceInfoDemoView: FiksFerdigServiceInfoViewModelDelegate {
    func fiksFerdigServiceInfoViewModelDidRequestReadMore(at url: URL) {
        print("🎉 did tap read more URL")
    }
}
