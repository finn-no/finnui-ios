import UIKit
import FinnUI
import FinniversKit

@MainActor
class DemoSuggestShippingEndpoint: SuggestShippingService {
    func suggestShipping(forAdId adId: String) async {
    }
}

final class SuggestShippingDemoView: UIView {
    var endpoint = DemoSuggestShippingEndpoint()

    private lazy var suggestShippingView: SuggestShippingView = {
        let suggestViewModel = SuggestShippingViewModel(
            title: "Fiks ferdig frakt og betaling",
            message: "Vi sier i fra til selger at du vil kjøpe og sende via FINN. Vi varsler deg når du kan legge inn et bud.",
            buttonTitle: "Be om fiks ferdig",
            adId: "dummy",
            suggestShippingService: endpoint)
        return SuggestShippingView.create(with: suggestViewModel)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(suggestShippingView)

        NSLayoutConstraint.activate([
            suggestShippingView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            suggestShippingView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingM),
            suggestShippingView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingM)
        ])
    }
}
