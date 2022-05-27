import UIKit
import FinnUI
import FinniversKit

class DemoSuggestShippingEndpoint: SuggestShippingService {
    var mockResult: SuggestShippingViewModel.SuggestShippingResult
    func suggestShipping() async -> SuggestShippingViewModel.SuggestShippingResult {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        return mockResult
    }

    init(mockResult: SuggestShippingViewModel.SuggestShippingResult) {
        self.mockResult = mockResult
    }
}

final class SuggestShippingDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption]  = [
        TweakingOption(title: "Suggest shipping successful", action: { [weak self] in
            self?.endpoint.mockResult = .success
        }),
        TweakingOption(title: "Suggest shipping error", action: { [weak self] in
            let errorViewModel = SuggestShippingViewModel.ErrorViewModel(
                title: "Hm... Vi klarte ikke å spørre selger",
                message: "Men kanskje du kan spørre for oss? Send en melding til selger og spør om å få bruke Fiks ferdig."
            )
            self?.endpoint.mockResult = .failure(errorViewModel)
        })
    ]

    let endpoint = DemoSuggestShippingEndpoint(mockResult: .success)

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
            suggestViewModel: suggestViewModel,
            suggestShippingService: endpoint,
            onSuccessfulSuggesting: { [unowned self] in
                self.successLabel.alpha = 1
                self.suggestShippingView.removeFromSuperview()
            }
        )
        return SuggestShippingView.create(with: suggestShippingViewModel)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
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
