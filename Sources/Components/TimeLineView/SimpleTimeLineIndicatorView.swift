import FinniversKit

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
            color: .borderDefault
        )
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: SimpleTimeLineIndicatorView.indicatorDotSize,
            height: UIView.noIntrinsicMetric
        )
    }
}
