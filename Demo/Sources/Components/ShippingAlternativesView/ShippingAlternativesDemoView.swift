import FinnUI
import UIKit


public class ShippingAlternativesDemoView: UIView {

    private lazy var shippingAlternativesView: ShippingAlternativesView = {
        let view = ShippingAlternativesView()
        view.delegate = self
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(shippingAlternativesView)

        NSLayoutConstraint.activate([
            shippingAlternativesView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingM),
            shippingAlternativesView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingM)
        ])

        let viewModel = ShippingAlternativesViewModel(text: "Hjelp til frakt", accessibilityLabel: "Hjelp til frakt", link: "https://www.finn.no")

        shippingAlternativesView.configure(viewModel)
    }
}

extension ShippingAlternativesDemoView: ShippingAlternativesViewDelegate {
    public func didSelectShippingAlternativesView(with link: String) {
        print("did tap button with link: \(link)")
    }
}