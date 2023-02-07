import FinniversKit

extension ProjectUnitsListView {
    class UnitItemTableViewCell: UITableViewCell {

        // MARK: - Internal properties

        static var verticalSpacing = CGFloat.spacingM

        // MARK: - Private properties

        private var rowView: RowView?

        // MARK: - Init

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            backgroundColor = .clear
        }

        required init?(coder: NSCoder) { fatalError() }

        // MARK: - Overrides

        override func prepareForReuse() {
            super.prepareForReuse()
            rowView?.removeFromSuperview()
            rowView = nil
        }

        // MARK: - Internal methods

        func configure(with unitItem: UnitItem) {
            let rowView = RowView(kind: .unit, labelValue: { unitItem.value(for: $0) })
            self.rowView = rowView

            contentView.addSubview(rowView)
            rowView.fillInSuperview(insets: .init(top: Self.verticalSpacing, bottom: -Self.verticalSpacing))
        }
    }
}

// MARK: - Private extensions

private extension ProjectUnitsListView.Column {
    var labelStyle: Label.Style {
        switch self {
        case .name:
            return .captionStrong
        case .floor, .area, .bedrooms, .totalPrice:
            return .caption
        }
    }

    var textColor: UIColor {
        switch self {
        case .name:
            return .textAction
        case .floor, .area, .bedrooms, .totalPrice:
            return .textPrimary
        }
    }

    var textAlignment: NSTextAlignment {
        switch self {
        case .name:
            return .left
        case .floor, .bedrooms, .area:
            return .center
        case .totalPrice:
            return .right
        }
    }
}
