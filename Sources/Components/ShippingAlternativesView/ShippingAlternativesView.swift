import FinniversKit
import UIKit

public protocol ShippingAlternativesViewDelegate: AnyObject {
    func didSelectShippingAlternativesView(with link: String)
}

public final class ShippingAlternativesView: UIView {

    public weak var delegate: ShippingAlternativesViewDelegate?

    private var viewModel: ShippingAlternativesViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            accessibilityLabel = viewModel.accessibilityLabel
            linkButton.setTitle(viewModel.text, for: .normal)
        }
    }

    private lazy var linkButton: Button = {
        let buttonStyle = Button.Style.flat.overrideStyle(
            borderWidth: 0.0,
            borderColor: nil,
            textColor: .link,
            highlightedBorderColor: nil,
            highlightedTextColor: .linkButtonHighlightedTextColor,
            margins: UIEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
            normalFont: UIFont.body
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
            linkButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            linkButton.topAnchor.constraint(equalTo: topAnchor),
            bottomAnchor.constraint(equalTo: linkButton.bottomAnchor)
        ])
    }

    // MARK: - Actions

    @objc private func handleLinkButtonTap() {
        guard let viewModel = viewModel else { return }
        delegate?.didSelectShippingAlternativesView(with: viewModel.link)
    }

    // MARK: - Public

    public func configure(_ viewModel: ShippingAlternativesViewModel) {
        self.viewModel = viewModel
    }

}
