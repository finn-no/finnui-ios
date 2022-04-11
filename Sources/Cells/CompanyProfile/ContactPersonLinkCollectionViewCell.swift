import UIKit
import FinniversKit

class ContactPersonLinkCollectionViewCell: UICollectionViewCell, OverflowCollectionViewCell {
    typealias Model = String

    // MARK: - Private properties

    private static let labelStyle = Label.Style.body
    private static let margins = UIEdgeInsets(vertical: .spacingS, horizontal: 0)

    private lazy var titleLabel = Label(style: .body, withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Self.margins.top),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Self.margins.leading),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Self.margins.trailing),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Self.margins.bottom)
        ])
    }

    // MARK: - Internal methods

    func configure(textColor: UIColor) {
        titleLabel.textColor = textColor
    }

    // MARK: - OverflowCollectionViewCell

    static func size(using title: String) -> CGSize {
        let font = Self.labelStyle.font
        let margins = Self.margins

        let width = title.width(withConstrainedHeight: .infinity, font: font) + (margins.leading + margins.trailing)
        let height = title.height(withConstrainedWidth: .infinity, font: font) + (margins.top + margins.bottom)

        return CGSize(width: width, height: height)
    }

    func configure(using title: String) {
        titleLabel.text = title
    }
}
