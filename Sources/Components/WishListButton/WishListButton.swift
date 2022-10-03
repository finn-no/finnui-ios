//
//  WishListButton.swift
//  


import Foundation
import FinniversKit

public protocol WishListButtonDelegate: AnyObject {
    func didTapButton(button: WishListButton)
}

public protocol WishListButtonViewModel {
    var adId: Int { get }
    var isWishListed: Bool { get }
    var title: String { get }
}

public final class WishListButton: UIView {

    private lazy var button: Button = {
        let button = Button(style: .default, withAutoLayout: true)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setTitle("Legg til i ønskelisten", for: .normal)
        button.tintColor = .primaryBlue
        button.adjustsImageWhenHighlighted = false
        button.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: .spacingM)
        button.addTarget(self, action: #selector(tapHandler), for: .touchUpInside)
        return button
    }()
    
    // MARK: - External properties

    public weak var delegate: WishListButtonDelegate?
    private var viewModel: WishListButtonViewModel?
    public var adId: Int? {
        viewModel?.adId
    }
    
    public var isWishListed: Bool = false {
        didSet {
            button.setTitle(viewModel?.title, for: .normal)
            let image = UIImage(systemName: viewModel?.isWishListed ?? false ? "star.fill" : "star")
            button.setImage(image, for: .normal)
            accessibilityLabel = viewModel?.title
        }
    }
    
    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        isAccessibilityElement = true
        accessibilityTraits = UIAccessibilityTraits.button

        // addSubview(iconImageView)
        addSubview(button)
        button.fillInSuperview()
    }
    
    // MARK: - Public methods

    public func configure(with viewModel: WishListButtonViewModel) {
        self.viewModel = viewModel
        self.isWishListed = viewModel.isWishListed
    }
    
    public func update() {
        self.isWishListed = viewModel?.isWishListed ?? false
    }
    
    // MARK: - Actions
    
    @objc func tapHandler(gesture: UITapGestureRecognizer) {
        print("--- WishListButton.tapHandler")
        delegate?.didTapButton(button: self)
    }
    
    
}
