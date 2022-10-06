import FinniversKit
import FinnUI
import UIKit

final class WishlistButtonDemoView: UIView {

    // MARK: - Private properties

    private lazy var wishlistButtonView = WishlistButtonView(withAutoLayout: true)
    private lazy var data = WishlistButtonData(isWishlisted: false, id: 42)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        wishlistButtonView.configure(with: data)
        wishlistButtonView.delegate = self
        addSubview(wishlistButtonView)

        NSLayoutConstraint.activate([
            wishlistButtonView.centerYAnchor.constraint(equalTo: centerYAnchor),
            wishlistButtonView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            wishlistButtonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM)
        ])
    }
}

// MARK: - WishlistButtonViewDelegate

extension WishlistButtonDemoView: WishlistButtonViewDelegate {
    func wishlistButtonDidSelect(_ wishlistButtonView: WishlistButtonView, button: Button, viewModel: WishlistButtonViewModel) {
        data.isWishlisted.toggle()
        wishlistButtonView.configure(with: data)
    }
}
