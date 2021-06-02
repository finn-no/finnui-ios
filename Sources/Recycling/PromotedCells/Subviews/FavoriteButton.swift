import UIKit
import FinniversKit

class FavoriteButton: UIButton {

    // MARK: - Internal properties

    private(set) var isFavorited = false

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        configure(isFavorited: isFavorited)
    }

    // MARK: - Configure

    func configure(isFavorited: Bool) {
        self.isFavorited = isFavorited
        let image = isFavorited ? UIImage(named: .favorited) : UIImage(named: .notFavorited)
        setImage(image, for: .normal)
    }

    func configureShadow() {
        imageView?.layer.shadowColor = UIColor.black.cgColor
        imageView?.layer.shadowOpacity = 0.7
        imageView?.layer.shadowRadius = 2
        imageView?.layer.shadowOffset = .zero
    }
}
