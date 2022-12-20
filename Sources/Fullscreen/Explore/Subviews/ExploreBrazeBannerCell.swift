import UIKit
import FinniversKit

final class ExploreBrazeBannerCell: UICollectionViewCell {
    var section: Int?
    private weak var banner: BrazePromotionView?

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
        banner.layoutSubviews()
        banner.sizeToFit()

        NSLayoutConstraint.activate([
            banner.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),
            banner.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            banner.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            banner.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
