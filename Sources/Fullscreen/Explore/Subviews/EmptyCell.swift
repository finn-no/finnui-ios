import UIKit
import FinniversKit

final class EmptyCell: UICollectionViewCell {
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 0),
            contentView.widthAnchor.constraint(equalToConstant: 0)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

