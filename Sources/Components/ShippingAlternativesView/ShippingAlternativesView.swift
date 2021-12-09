import FinniversKit
import UIKit

public protocol ShippingAlternativesViewDelegate: AnyObject {
    func didSelectShippingAlternativesView()
}

public final class ShippingAlternativesView: UIView {

    public weak var delegate: ShippingAlternativesViewDelegate?

    private lazy var linkButton: Button = {
        let buttonStyle = Button.Style.flat.overrideStyle(
            borderWidth: 0.0,
            borderColor: nil,
            textColor: .link,
            highlightedBorderColor: nil,
            highlightedTextColor: .linkButtonHighlightedTextColor
        )
        let button = Button(style: buttonStyle)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLinkButtonTap), for: .touchUpInside)
        return button
    }()

    public init() {
        super.init(frame: .zero)
        isAccessibilityElement = true
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError()
    }

    private func setup() {
        backgroundColor = .bgPrimary

        addSubview(linkButton)

        NSLayoutConstraint.activate([
            linkButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            linkButton.topAnchor.constraint(equalTo: topAnchor),
            bottomAnchor.constraint(equalTo: linkButton.bottomAnchor)
        ])
    }

    // MARK: - Actions

    @objc private func handleLinkButtonTap() {
        delegate?.didSelectShippingAlternativesView()
    }

    // MARK: - Public

    public func configure(_ viewModel: ShippingAlternativesViewModel) {
        accessibilityLabel = viewModel.accessibilityLabel
        linkButton.setTitle(viewModel.text, for: .normal)
    }

}
