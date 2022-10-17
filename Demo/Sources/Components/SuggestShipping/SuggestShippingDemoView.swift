import UIKit
import FinnUI
import FinniversKit

<<<<<<< HEAD
@MainActor
class DemoSuggestShippingEndpoint: SuggestShippingService {
    func suggestShipping(forAdId adId: String) async {
    }
}

final class SuggestShippingDemoView: UIView {
    var endpoint = DemoSuggestShippingEndpoint()

    private lazy var suggestShippingView: SuggestShippingView = {
=======
final class SuggestShippingDemoView: UIView {
    private lazy var suggestShippingView: SuggestShippingView = {
        let actionModels = [
            AlertModel<Bool>.ActionModel(
                title: "Confirm",
                style: .default,
                value: true
            ),
            AlertModel<Bool>.ActionModel(
                title: "Deny",
                style: .default,
                value: false
            )
        ]
        let alertModel = AlertModel(
            actionModels: actionModels,
            title: "Confirm suggest shipping",
            message: "Do you really want to suggest shipping?",
            preferredStyle: .alert
        )
>>>>>>> master
        let suggestViewModel = SuggestShippingViewModel(
            title: "Fiks ferdig frakt og betaling",
            message: "Vi sier i fra til selger at du vil kjøpe og sende via FINN. Vi varsler deg når du kan legge inn et bud.",
            buttonTitle: "Be om fiks ferdig",
            adId: "dummy",
<<<<<<< HEAD
            suggestShippingService: endpoint)
=======
            alertModel: alertModel)
        suggestViewModel.delegate = self
>>>>>>> master
        return SuggestShippingView(viewModel: suggestViewModel, withAutoLayout: true)
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
<<<<<<< HEAD
=======

extension SuggestShippingDemoView: SuggestShippingViewModelDelegate {
    func didRequestShipping(suggestShippingViewModel: SuggestShippingViewModel) {
        print("🎉 didRequestShipping called")
    }
}
>>>>>>> master
