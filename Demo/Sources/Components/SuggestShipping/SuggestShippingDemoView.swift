import UIKit
import FinnUI
import FinniversKit

@MainActor
class DemoSuggestShippingEndpoint: SuggestShippingService {
    var mockResult: SuggestShippingViewModel.SuggestShippingResult
    var onSuccess: () -> Void

    func suggestShipping(forAdId adId: String) async -> SuggestShippingViewModel.SuggestShippingResult {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        if case .success = mockResult {
            onSuccess()
        }
        return mockResult
    }

    init(mockResult: SuggestShippingViewModel.SuggestShippingResult, onSuccess: @escaping () -> Void) {
        self.mockResult = mockResult
        self.onSuccess = onSuccess
    }
}

extension DemoSuggestShippingEndpoint: SuggestShippingErrorViewModelButtonHandler {
    func didTapButton() {

    }
}

final class SuggestShippingDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption]  = [
        TweakingOption(title: "Suggest shipping successful", action: { [weak self] in
            self?.endpoint.mockResult = .success
        }),
        TweakingOption(title: "Suggest shipping error", action: { [weak self] in
            guard let strongSelf = self else { return }

            let errorViewModel = SuggestShippingViewModel.ErrorViewModel(
                title: "Hm... Vi klarte ikke å spørre selger",
                message: "Men kanskje du kan spørre for oss? Send en melding til selger og spør om å få bruke Fiks ferdig.",
                buttonTitle: "Lære mer om fiks Ferdig",
                buttonHandler: strongSelf.endpoint
            )
            strongSelf.endpoint.mockResult = .failure(errorViewModel)
        })
    ]

    var endpoint: DemoSuggestShippingEndpoint!

    private lazy var successLabel: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var suggestShippingView: SuggestShippingView = {
        let suggestViewModel = SuggestShippingViewModel.SuggestViewModel(
            title: "Fiks ferdig frakt og betaling",
            message: "Vi sier i fra til selger at du vil kjøpe og sende via FINN. Vi varsler deg når du kan legge inn et bud.",
            buttonTitle: "Be om fiks ferdig")
        let suggestShippingViewModel = SuggestShippingViewModel(
            adId: "dummy",
            suggestViewModel: suggestViewModel,
            suggestShippingService: endpoint
        )
        return SuggestShippingView.create(with: suggestShippingViewModel)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        endpoint = DemoSuggestShippingEndpoint(
            mockResult: .success,
            onSuccess: { [unowned self] in
                self.successLabel.alpha = 1
                self.suggestShippingView.removeFromSuperview()
            }
        )

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(suggestShippingView)
        addSubview(successLabel)

        successLabel.text = "Request shipping was successful 🎉"
        successLabel.alpha = 0

        let successTopConstraint = successLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        successTopConstraint.priority = .defaultLow

        NSLayoutConstraint.activate([
            suggestShippingView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            suggestShippingView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingM),
            suggestShippingView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingM),

            successLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingM),
            successLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingM),
            successLabel.topAnchor.constraint(equalTo: suggestShippingView.bottomAnchor, constant: .spacingL),
            successTopConstraint
        ])
    }
}
