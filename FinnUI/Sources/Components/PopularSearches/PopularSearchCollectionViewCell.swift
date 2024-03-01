import UIKit
import FinniversKit

class PopularSearchCollectionViewCell: UICollectionViewCell, OverflowCollectionViewCell {
    typealias Model = String

    static let padding = UIEdgeInsets(vertical: .spacingS, horizontal: .spacingM)
    static let titleLabelStyle: Label.Style = .body

    // MARK: - Private properties

    private lazy var titleLabel = Label(style: Self.titleLabelStyle, withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        clipsToBounds = false
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(titleLabel)
        titleLabel.fillInSuperview(insets: Self.padding.toLayoutConstraintInsets)
    }

    // MARK: - Public methods

    func configure(using title: String) {
        titleLabel.text = title
    }

    static func size(using title: String) -> CGSize {
        let font = Self.titleLabelStyle.font
        let padding = Self.padding

        let width = title.width(withConstrainedHeight: .infinity, font: font) + (padding.leading + padding.trailing)
        let height = title.height(withConstrainedWidth: .infinity, font: font) + (padding.top + padding.bottom)

        return CGSize(width: width, height: height)
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = 1
        layer.borderColor = .imageBorder
        layer.cornerRadius = bounds.height / 2
    }
}

// MARK: - Private extensions

private extension UIEdgeInsets {
    var toLayoutConstraintInsets: UIEdgeInsets {
        UIEdgeInsets(top: top, leading: leading, bottom: -bottom, trailing: -trailing)
    }
}

