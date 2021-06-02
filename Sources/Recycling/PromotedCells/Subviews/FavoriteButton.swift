import UIKit
import FinniversKit

protocol FavoriteButtonDelegate: AnyObject {
    func favoriteButtonDidToggleFavoriteState(_ button: FavoriteButton)
}

class FavoriteButton: UIView {

    // MARK: - Internal properties

    weak var delegate: FavoriteButtonDelegate?
    private(set) var isFavorited = false

    // MARK: - Private properties

    private lazy var button: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(button)
        button.fillInSuperview()
        configure(isFavorited: isFavorited)
    }

    // MARK: - Configure

    func configure(isFavorited: Bool) {
        self.isFavorited = isFavorited
        let image = isFavorited ? UIImage(named: .favorited) : UIImage(named: .notFavorited)
        button.setImage(image, for: .normal)
    }

    func configureShadow() {
        button.imageView?.layer.shadowColor = UIColor.black.cgColor
        button.imageView?.layer.shadowOpacity = 0.7
        button.imageView?.layer.shadowRadius = 2
        button.imageView?.layer.shadowOffset = .zero
    }

    // MARK: - Actions

    @objc private func handleButtonTap() {
        delegate?.favoriteButtonDidToggleFavoriteState(self)
    }
}
