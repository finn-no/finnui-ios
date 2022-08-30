import FinniversKit

public struct SimpleTimeLineIndicatorProvider: TimeLineIndicatorProvider {
    private static let textVerticalMargin: CGFloat = .spacingXS

    public let width: CGFloat = SimpleTimeLineIndicatorView.indicatorDotSize

    private var dotOffset: CGFloat = 0

    public init(font: UIFont) {
        self.dotOffset = SimpleTimeLineIndicatorProvider.textVerticalMargin + font.capHeight / 2
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
