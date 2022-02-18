import UIKit
import FinniversKit

class AgentPhoneNumberCollectionViewCell: UICollectionViewCell, OverflowCollectionViewCell {
    typealias Model = String

    // MARK: - Private properties

    private static let labelStyle = Label.Style.body
    private static let margins = UIEdgeInsets(vertical: .spacingS, horizontal: 0)

    private lazy var phoneNumberLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.textColor = .textAction
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        contentView.addSubview(phoneNumberLabel)

        NSLayoutConstraint.activate([
            phoneNumberLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Self.margins.top),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Self.margins.leading),
            phoneNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Self.margins.trailing),
            phoneNumberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Self.margins.bottom)
        ])
    }

    // MARK: - OverflowCollectionViewCell

    static func size(using phoneNumber: String) -> CGSize {
        let font = Self.labelStyle.font
        let margins = Self.margins

        let width = phoneNumber.width(withConstrainedHeight: .infinity, font: font) + (margins.leading + margins.trailing)
        let height = phoneNumber.height(withConstrainedWidth: .infinity, font: font) + (margins.top + margins.bottom)

        return CGSize(width: width, height: height)
    }

    func configure(using phoneNumber: String) {
        phoneNumberLabel.text = phoneNumber
    }
}
