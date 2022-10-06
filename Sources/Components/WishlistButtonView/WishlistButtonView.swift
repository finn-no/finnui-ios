import FinniversKit
import UIKit

/// View model for populating a wishlist button view
public protocol WishlistButtonViewModel {
    /// ID of the wishlistable item
    var id: Int { get }
    /// Title of the button
    var title: String { get }
    /// A boolean value indicating whether the item is wishlisted
    var isWishlisted: Bool { get }
}

/// Delegate for handling wishlist button interaction
public protocol WishlistButtonViewDelegate: AnyObject {
    
    /// Handler called when the wishlist button is tapped.
    /// - Parameters:
    ///   - wishlistButtonView: The view that called this handler
    ///   - button: The button that was tapped
    ///   - viewModel: View model of the view that called this handler
    func wishlistButtonDidSelect(
        _ wishlistButtonView: WishlistButtonView,
        button: Button,
        viewModel: WishlistButtonViewModel
    )
}

/// A view for wishlisting of an object
public class WishlistButtonView: UIView {
    // MARK: - Public properties
    
    /// The object that acts as the delegate of the wishlist button
    public weak var delegate: WishlistButtonViewDelegate?

    // MARK: - Private properties

    private var viewModel: WishlistButtonViewModel?
    private let flatButtonStyle = Button.Style.flat.overrideStyle(margins: UIEdgeInsets.zero)

    private lazy var button: Button = {
        let button = Button(style: flatButtonStyle, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets(leading: .spacingS)
        button.imageEdgeInsets = UIEdgeInsets(top: -.spacingXS)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.contentHorizontalAlignment = .leading
        button.adjustsImageWhenHighlighted = false
        return button
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(button)
        button.fillInSuperview()
    }

    // MARK: - Public methods
    
    
    /// Configure the view with a view model
    /// - Parameter viewModel: A view model based on a wishlistable item
    public func configure(with viewModel: WishlistButtonViewModel) {
        self.viewModel = viewModel
        button.setTitle(viewModel.title, for: .normal)
        // TODO: Update images
        let image = viewModel.isWishlisted ? UIImage(named: .favoriteActive) : UIImage(named: .favoriteDefault)
        button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .btnAction
    }

    // MARK: - Private methods

    @objc private func handleButtonTap() {
        guard let viewModel = viewModel else { return }
        delegate?.wishlistButtonDidSelect(self, button: button, viewModel: viewModel)
    }
}
