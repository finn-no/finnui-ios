import UIKit
import FinniversKit

struct ContactPersonLinkViewModel {
    let title: String
    let textColor: UIColor
}

class ContactPersonLinkCollectionViewCell: UICollectionViewCell, OverflowCollectionViewCell {
    typealias Model = ContactPersonLinkViewModel

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

    // MARK: - OverflowCollectionViewCell

    static func size(using viewModel: ContactPersonLinkViewModel) -> CGSize {
        let font = Self.labelStyle.font
        let margins = Self.margins

        let width = viewModel.title.width(withConstrainedHeight: .infinity, font: font) + (margins.leading + margins.trailing)
        let height = viewModel.title.height(withConstrainedWidth: .infinity, font: font) + (margins.top + margins.bottom)

        return CGSize(width: width, height: height)
    }

    func configure(using viewModel: ContactPersonLinkViewModel) {
        titleLabel.text = viewModel.title
        titleLabel.textColor = viewModel.textColor
    }
}
