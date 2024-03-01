import UIKit
import FinniversKit

final class ExploreBrazeBannerCell: UICollectionViewCell {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure
    public func configure(banner: BrazePromotionView) {
        contentView.addSubview(banner)

        NSLayoutConstraint.activate([
            banner.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),
            banner.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            banner.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            banner.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    override func prepareForReuse() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
    }
}
