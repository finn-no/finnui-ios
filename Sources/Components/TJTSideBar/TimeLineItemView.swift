import FinniversKit
import UIKit

public struct TimeLineItem {
    let title: String

    public init(title: String) {
        self.title = title
    }
}

final class TimeLineItemView: UIStackView {
    private let title: String
    private let type: ItemType

    private let titleLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.textColor = .licorice
        label.numberOfLines = 0
        return label
    }()

    private let positionView: PositionView
    private let textVerticalMargin: CGFloat = .spacingXS
    private let positionLeftInset: CGFloat = .spacingXS
    private let positionAndLabelSpacing: CGFloat = .spacingXS + .spacingS

    static let font = UIFont.caption

    init(withTitle title: String, type: ItemType, withAutoLayout: Bool = false) {
        self.title = title
        self.type = type
        self.positionView = PositionView(style: type, withAutoLayout: true)
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        axis = .horizontal
        spacing = .spacingM

        directionalLayoutMargins = .init(
            top: 0,
            leading: .spacingXS,
            bottom: 0,
            trailing: 0
        )
        isLayoutMarginsRelativeArrangement = true

        positionView.setContentCompressionResistancePriority(.required, for: .horizontal)
        positionView.setContentHuggingPriority(.required, for: .horizontal)

        addArrangedSubviews([
            positionView,
            titleLabel
        ])

        positionView.widthAnchor.constraint(equalToConstant: PositionView.indicatorDotSize).isActive = true
        titleLabel.text = title
        invalidateIntrinsicContentSize()
    }

    func requiredHeight(forWidth width: CGFloat) -> CGFloat {
        let availableWidth
        = width
        - positionLeftInset
        - PositionView.indicatorDotSize
        - positionAndLabelSpacing

        let textConstraintRect = CGSize(
            width: availableWidth,
            height: .greatestFiniteMagnitude
        )
        let textBoundingBox = title.boundingRect(
            with: textConstraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: TimeLineItemView.font],
            context: nil
        )
        let neededTextHeight = ceil(textBoundingBox.height + textVerticalMargin * 2)
        return calculateHeight(for: neededTextHeight)
    }

    private func calculateHeight(for textHeight: CGFloat) -> CGFloat {
        var currentHeight
        = PositionView.indicatorDotSize
        + PositionView.dotSpacing * 2
        + PositionView.fillingDotSize

        while currentHeight < textHeight {
            currentHeight += PositionView.dotSpacing * 2 + PositionView.fillingDotSize * 2
        }
        return currentHeight
    }

    override var intrinsicContentSize: CGSize {
        let newHeight = requiredHeight(forWidth: bounds.width)
        return CGSize(
            width: UIView.noIntrinsicMetric,
            height: newHeight
        )
    }
}

// MARK: - TimeLineItemView.ItemType

extension TimeLineItemView {
    public enum ItemType {
        case starting
        case middle
        case final
    }
}

// MARK: - TimeLineItemView.PositionView

extension TimeLineItemView {
    final class PositionView: UIView {
        static var indicatorDotSize: CGFloat = 8
        static var fillingDotSize: CGFloat = 2
        static var dotSpacing: CGFloat = 3

        private var dotLayers: [CAShapeLayer] = []
        private let style: TimeLineItemView.ItemType

        init(style: TimeLineItemView.ItemType, withAutoLayout: Bool = false) {
            self.style = style
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = !withAutoLayout

            layer.masksToBounds = true
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func layoutSubviews() {
            dotLayers.forEach { $0.removeFromSuperlayer() }

            addDot(
                at: CGPoint(
                    x: bounds.midX,
                    y: bounds.midY
                ),
                radius: PositionView.indicatorDotSize / 2
            )

            var currentOffset: CGFloat
            = PositionView.indicatorDotSize / 2
            + PositionView.dotSpacing
            + PositionView.fillingDotSize / 2

            while center.y - currentOffset >= 0 {
                if style != .final {
                    addDot(
                        at: CGPoint(
                            x: bounds.midX,
                            y: bounds.midY + currentOffset
                        ),
                        radius: PositionView.fillingDotSize / 2
                    )
                }

                if style != .starting {
                    addDot(
                        at: CGPoint(
                            x: bounds.midX,
                            y: bounds.midY - currentOffset
                        ),
                        radius: PositionView.fillingDotSize / 2
                    )
                }
                currentOffset += PositionView.fillingDotSize + PositionView.dotSpacing
            }
        }

        private func addDot(at position: CGPoint, radius: CGFloat) {
            let circlePath = UIBezierPath(
                arcCenter: position,
                radius: radius,
                startAngle: 0,
                endAngle: .pi * 2,
                clockwise: true
            )

            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            shapeLayer.fillColor = UIColor.sardine.cgColor
            layer.addSublayer(shapeLayer)
            dotLayers.append(shapeLayer)
        }

        override var intrinsicContentSize: CGSize {
            return CGSize(
                width: 8,
                height: UIView.noIntrinsicMetric
            )
        }
    }
}
