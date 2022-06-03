import UIKit
import FinnUI
import FinniversKit

final class ShippingRequestErrorDemoView: UIView {
    private lazy var shippingRequestErrorView: ShippingRequestErrorView = {
        let errorViewModel = ShippingRequestErrorViewModel(
            title: "Fiks ferdig frakt og betaling",
            message: "Vi sier i fra til selger at du vil kjøpe og sende via FINN. Vi varsler deg når du kan legge inn et bud.",
            buttonTitle: "Be om fiks ferdig",
            buttonHandler: ErrorButtonHandler()
        )
        return ShippingRequestErrorView.create(with: errorViewModel)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(shippingRequestErrorView)

        NSLayoutConstraint.activate([
            shippingRequestErrorView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            shippingRequestErrorView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingM),
            shippingRequestErrorView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingM)
        ])
    }
}

private final class ErrorButtonHandler: SuggestShippingErrorViewModelButtonHandler {
    func didTapButton() {
    }
}