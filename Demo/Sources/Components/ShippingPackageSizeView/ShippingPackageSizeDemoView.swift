import UIKit
import FinniversKit
import FinnUI

class ShippingPackageSizeDemoView: UIView {

    // MARK: - Private properties

    private lazy var shippingPackageSizeView: ShippingPackageSizeView = {
        let view = ShippingPackageSizeView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        shippingPackageSizeView.configure(with: .demoItems)

        addSubview(shippingPackageSizeView)

        NSLayoutConstraint.activate([
            shippingPackageSizeView.centerYAnchor.constraint(equalTo: centerYAnchor),
            shippingPackageSizeView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            shippingPackageSizeView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
        ])
    }
}

// MARK: - ShippingPackageSizeViewDelegate

extension ShippingPackageSizeDemoView: ShippingPackageSizeViewDelegate {
    func shippingPackageSizeView(_ view: ShippingPackageSizeView, didSelectItemModel itemModel: ShippingPackageSizeItemModel) {
        print("👉 Did select package option with size: \(itemModel.size)")
    }

    func shippingPackageSizeViewDidRemoveSelection(_ view: ShippingPackageSizeView) {
        print("👉 Did remove package size selection")
    }
}

// MARK: - Private extensions

private extension Array where Element == ShippingPackageSizeItemModel {
    static var demoItems: [ShippingPackageSizeItemModel] = [
        ShippingPackageSizeItemModel(
            size: .small,
            title: "Liten",
            body: "Opptil 5 kg",
            helpText: "Opptil 5 kg / H 25cm / L 35cm / D 12cm",
            isInitiallySelected: true
        ),
        ShippingPackageSizeItemModel(
            size: .large,
            title: "Stor",
            body: "Opptil 10 kg",
            helpText: "Opptil 10 kg / Lengde: 120cm / Lengde + omkrets: 240cm",
            isInitiallySelected: false
        ),
        ShippingPackageSizeItemModel(
            size: .extraLarge,
            title: "Ekstra stor",
            body: "Opptil 20 kg",
            helpText: "Opptil 20 kg / Lengde: 120cm / Lengde + omkrets: 240cm",
            isInitiallySelected: false
        ),
    ]
}
