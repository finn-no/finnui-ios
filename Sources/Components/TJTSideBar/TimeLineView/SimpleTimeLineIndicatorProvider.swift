import FinniversKit

public struct SimpleTimeLineIndicatorProvider: TimeLineIndicatorProvider {
    private static let textVerticalMargin: CGFloat = .spacingXS

    public let width: CGFloat = SimpleTimeLineIndicatorView.indicatorDotSize

    private let font: UIFont
    private var dotOffset: CGFloat = 0

    public init(font: UIFont) {
        self.font = font

        let fontHeight = "I".height(withConstrainedWidth: .greatestFiniteMagnitude, font: font)
        self.dotOffset = SimpleTimeLineIndicatorProvider.textVerticalMargin + fontHeight / 2
    }

    public func createView(withStyle itemStyle: TimeLineItemStyle) -> UIView {
        let positionView = SimpleTimeLineIndicatorView(withAutoLayout: true)
        positionView.dotOffset = dotOffset
        return positionView
    }

    public func updatedHeight(for textHeight: CGFloat) -> (height: CGFloat, verticalOffset: CGFloat) {
        let newTextHeight = textHeight + 2 * SimpleTimeLineIndicatorProvider.textVerticalMargin
        let verticalOffset = dotOffset - SimpleTimeLineIndicatorProvider.textVerticalMargin

        return (
            height: newTextHeight,
            verticalOffset: verticalOffset
        )
    }
}

final class SimpleTimeLineIndicatorView: UIView {
    static var indicatorDotSize: CGFloat = 8

    private var dotLayer: CAShapeLayer?

    var dotOffset: CGFloat = 0

    override func layoutSubviews() {
        dotLayer?.removeFromSuperlayer()

        let indicatorDotY = dotOffset + SimpleTimeLineIndicatorView.indicatorDotSize / 2
        dotLayer = layer.addCircle(
            at: CGPoint(
                x: bounds.midX,
                y: indicatorDotY
            ),
            radius: DottedTimeLineIndicatorView.indicatorDotSize / 2,
            color: .timelineIndicator
        )
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: SimpleTimeLineIndicatorView.indicatorDotSize,
            height: UIView.noIntrinsicMetric
        )
    }

}

extension CALayer {
    public func addCircle(at position: CGPoint, radius: CGFloat, color: UIColor) -> CAShapeLayer {
        let circlePath = UIBezierPath(
            arcCenter: position,
            radius: radius,
            startAngle: 0,
            endAngle: .pi * 2,
            clockwise: true
        )

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = color.cgColor
        addSublayer(shapeLayer)
        return shapeLayer
    }
}

// MARK: - Private extensions

private extension UIColor {
    static var timelineIndicator = dynamicColor(defaultColor: .sardine, darkModeColor: .darkSardine)
}
