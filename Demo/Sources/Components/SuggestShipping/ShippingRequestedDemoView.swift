import Foundation
import UIKit
import FinnUI

final class ShippingRequestedDemoView: UIView {
    private lazy var shippingRequestedView: ShippingRequestedView = {
        let viewModel = ShippingRequestedViewModel(
            title: "Snart kan du gi bud!",
            message: "Selger må registrere fraktadresse først, så sier vi i fra når du kan bruke Fiks ferdig."
        )
        return ShippingRequestedView.create(with: viewModel)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(shippingRequestedView)

        NSLayoutConstraint.activate([
            shippingRequestedView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            shippingRequestedView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingM),
            shippingRequestedView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingM),
        ])
    }
}