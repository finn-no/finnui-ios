import FinniversKit

extension ProjectUnitsListView {
    class RowView: UIView {
        enum Kind {
            case header
            case unit
        }

        // MARK: - Private properties

        private lazy var verticalStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)

        private lazy var horizontalStackView: UIStackView = {
            let stackView = UIStackView(axis: .horizontal, spacing: 0, withAutoLayout: true)
            stackView.alignment = .center
            stackView.distribution = .equalSpacing
            return stackView
        }()

        private lazy var separator: UIView = {
            let view = UIView(withAutoLayout: true)
            view.backgroundColor = .tableViewSeparator
            return view
        }()

        // MARK: - Init

        init(kind: Kind, addSeparator: Bool = false, labelValue: (Column) -> String) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            setup(kind: kind, addSeparator: addSeparator, labelValue: labelValue)
        }

        required init?(coder: NSCoder) { fatalError() }

        // MARK: - Setup

        private func setup(kind: Kind, addSeparator: Bool, labelValue: (Column) -> String) {
            verticalStackView.addArrangedSubview(horizontalStackView)

            addSubview(verticalStackView)
            verticalStackView.fillInSuperview()

            let labels = Column.allCases.map { column in
                let text = labelValue(column)
                switch kind {
                case .header:
                    return createLabel(style: .captionStrong, column: column, text: text)
                case .unit:
                    return createLabel(style: column.unitLabelStyle, column: column, textColor: column.unitTextColor, text: text)
                }
            }
            horizontalStackView.addArrangedSubviews(labels)

            let lastColumnIndex = Column.allCases.count - 1
            let threeFourths: CGFloat = 3/4

            horizontalStackView.arrangedSubviews.enumerated().forEach { index, label in
                let widthMultiplier: CGFloat

                // The first columns will share 75% of the width, while price will get the remaining 25%.
                if index < lastColumnIndex {
                    widthMultiplier = threeFourths / CGFloat(lastColumnIndex)
                } else {
                    widthMultiplier = 1.0 - threeFourths
                }

                label.widthAnchor.constraint(equalTo: horizontalStackView.widthAnchor, multiplier: widthMultiplier).isActive = true
            }

            if addSeparator {
                separator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
                verticalStackView.addArrangedSubview(separator)
            }
        }

        // MARK: - Private methods

        private func createLabel(style: Label.Style, column: Column, textColor: UIColor = .textPrimary, text: String) -> Label {
            let label = Label(style: style, numberOfLines: 0, textColor: textColor, withAutoLayout: true)
            label.textAlignment = column.textAlignment
            label.text = text
            return label
        }
    }
}

// MARK: - Private extensions

private extension ProjectUnitsListView.Column {
    var unitLabelStyle: Label.Style {
        switch self {
        case .name:
            return .captionStrong
        case .floor, .area, .bedrooms, .totalPrice:
            return .caption
        }
    }

    var unitTextColor: UIColor {
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
