import UIKit

final class DottedTimeLineIndicatorView: UIView {
    static var indicatorDotSize: CGFloat = 8
    static var fillingDotSize: CGFloat = 2
    static var dotSpacing: CGFloat = 3

    private var dotLayers: [CAShapeLayer] = []
    private let style: TimeLineItemStyle

    var dotOffset: CGFloat = 0

    init(style: TimeLineItemStyle, withAutoLayout: Bool = false) {
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

        let indicatorDotY = dotOffset + DottedTimeLineIndicatorView.indicatorDotSize / 2
        dotLayers.append(
            layer.addCircle(
                at: CGPoint(
                    x: bounds.midX,
                    y: indicatorDotY
                ),
                radius: DottedTimeLineIndicatorView.indicatorDotSize / 2,
                color: .timelineIndicator
            )
        )

        var currentOffset: CGFloat
        = DottedTimeLineIndicatorView.indicatorDotSize / 2
        + DottedTimeLineIndicatorView.dotSpacing
        + DottedTimeLineIndicatorView.fillingDotSize / 2

        var upwardsOffset = indicatorDotY - currentOffset
        var downwardsOffset = indicatorDotY + currentOffset
        while upwardsOffset >= 0 || downwardsOffset <= bounds.maxY {
            if style != .starting, upwardsOffset >= 0 {
                dotLayers.append(
                    layer.addCircle(
                        at: CGPoint(
                            x: bounds.midX,
                            y: upwardsOffset
                        ),
                        radius: DottedTimeLineIndicatorView.fillingDotSize / 2,
                        color: .timelineIndicator
                    )
                )
            }

            if style != .final, downwardsOffset <= bounds.maxY {
                dotLayers.append(
                    layer.addCircle(
                        at: CGPoint(
                            x: bounds.midX,
                            y: downwardsOffset
                        ),
                        radius: DottedTimeLineIndicatorView.fillingDotSize / 2,
                        color: .timelineIndicator
                    )
                )
            }
            currentOffset = DottedTimeLineIndicatorView.fillingDotSize + DottedTimeLineIndicatorView.dotSpacing
            upwardsOffset -= currentOffset
            downwardsOffset += currentOffset
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: 8,
            height: UIView.noIntrinsicMetric
        )
    }
}

// MARK: - Private extensions

private extension UIColor {
    static var timelineIndicator = dynamicColor(defaultColor: .sardine, darkModeColor: .darkSardine)
}
