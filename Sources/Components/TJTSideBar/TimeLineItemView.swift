import FinniversKit
import UIKit

public struct TimeLineItem {
    let title: String

    public init(title: String) {
        self.title = title
    }
}

final class TimeLineItemView: UIView {
    private let title: String
    private let type: ItemType
    private let positionView: PositionView
    private let titleLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()

    private let textVerticalMargin: CGFloat = .spacingXS
    private let positionLeftInset: CGFloat = .spacingXS
    private let positionAndLabelSpacing: CGFloat = .spacingXS + .spacingS
    private var fontHeight: CGFloat = "I".height(withConstrainedWidth: .greatestFiniteMagnitude, font: .caption)
    private var titleTopConstraint: NSLayoutConstraint!

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
        addSubview(positionView)

        NSLayoutConstraint.activate([
            positionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: positionLeftInset),
            positionView.topAnchor.constraint(equalTo: topAnchor),
            positionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        positionView.setContentCompressionResistancePriority(.required, for: .horizontal)
        positionView.setContentHuggingPriority(.required, for: .horizontal)

        addSubview(titleLabel)

        titleTopConstraint = titleLabel.topAnchor.constraint(equalTo: topAnchor)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: positionView.trailingAnchor, constant: positionAndLabelSpacing),
            titleTopConstraint,
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        titleLabel.text = title
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
        let currentTextHeight = ceil(textBoundingBox.height)
        let (height, dotOffset) = calculateHeight(for: currentTextHeight)
        titleTopConstraint.constant = dotOffset - textVerticalMargin
        positionView.dotOffset = dotOffset
        return height
    }

    private func calculateHeight(for textHeight: CGFloat) -> (height: CGFloat, dotOffset: CGFloat) {
        var newTextHeight = textHeight
        let half = fontHeight / 2 + textVerticalMargin
        var dotMidY = PositionView.indicatorDotSize / 2
        + PositionView.dotSpacing
        + PositionView.fillingDotSize / 2

        let offset = PositionView.dotSpacing + PositionView.fillingDotSize

        while dotMidY <= half {
            dotMidY += offset
        }

        newTextHeight += dotMidY - half

        var bottomY = dotMidY
            + PositionView.indicatorDotSize / 2
            + PositionView.dotSpacing
            + PositionView.fillingDotSize / 2

        while bottomY <= newTextHeight + 2 * textVerticalMargin {
            bottomY += offset
        }

        newTextHeight += bottomY - (newTextHeight + 2 * textVerticalMargin)

        return (
            height: newTextHeight + 2 * textVerticalMargin,
            dotOffset: dotMidY - textVerticalMargin
        )
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

        var dotOffset: CGFloat = 0 {
            didSet {
                guard dotOffset != oldValue else {
                    return
                }

                layoutIfNeeded()
            }
        }

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

            let indicatorDotY = dotOffset + PositionView.indicatorDotSize / 2
            addDot(
                at: CGPoint(
                    x: bounds.midX,
                    y: indicatorDotY
                ),
                radius: PositionView.indicatorDotSize / 2
            )

            var currentOffset: CGFloat
            = PositionView.indicatorDotSize / 2
            + PositionView.dotSpacing
            + PositionView.fillingDotSize / 2

            var upwardsOffset = indicatorDotY - currentOffset
            var downwardsOffset = indicatorDotY + currentOffset
            while upwardsOffset >= 0 || downwardsOffset <= bounds.maxY {
                if style != .starting, upwardsOffset >= 0 {
                    addDot(
                        at: CGPoint(
                            x: bounds.midX,
                            y: upwardsOffset
                        ),
                        radius: PositionView.fillingDotSize / 2
                    )
                }

                if style != .final, downwardsOffset <= bounds.maxY {
                    addDot(
                        at: CGPoint(
                            x: bounds.midX,
                            y: downwardsOffset
                        ),
                        radius: PositionView.fillingDotSize / 2
                    )
                }
                currentOffset = PositionView.fillingDotSize + PositionView.dotSpacing
                upwardsOffset -= currentOffset
                downwardsOffset += currentOffset
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
