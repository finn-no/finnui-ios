import UIKit
import FinniversKit

class RealestateSoldStateExpandToggleView: UIView {

    // MARK: - Private properties

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.tintColor = .textPrimary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.size.height, bounds.size.width) / 2
    }

    // MARK: - Setup

    private func setup() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: centerYAnchor, constant: .spacingXS),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM),
        ])
    }

    // MARK: - Internal methods

    func configure(with image: UIImage) {
        imageView.image = image
    }
}
