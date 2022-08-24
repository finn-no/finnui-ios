import FinniversKit

public struct DottedTimeLineIndicatorProvider: TimeLineIndicatorProvider {
    private static let textVerticalMargin: CGFloat = .spacingXS

    public let width: CGFloat = DottedTimeLineIndicatorView.indicatorDotSize

    private let font: UIFont
    private var dotOffset: CGFloat = 0
    private var fontHeight: CGFloat {
        "I".height(withConstrainedWidth: .greatestFiniteMagnitude, font: font)
    }

    private var upperHalf: CGFloat {
        fontHeight / 2 + DottedTimeLineIndicatorProvider.textVerticalMargin
    }

    public init(font: UIFont) {
        self.font = font
        self.dotOffset = calculateDotOffset()
    }

    private func calculateDotOffset() -> CGFloat {
        // The indicator dot has to be at the center of the first line, so we're calculating it
        // by taking half size of a line and the top offset.
        var dotMidY = DottedTimeLineIndicatorView.indicatorDotSize / 2
        + DottedTimeLineIndicatorView.dotSpacing
        + DottedTimeLineIndicatorView.fillingDotSize / 2

        let offset = DottedTimeLineIndicatorView.dotSpacing + DottedTimeLineIndicatorView.fillingDotSize

        while dotMidY <= upperHalf {
            dotMidY += offset
        }

        return dotMidY
    }

    public func createView(withStyle itemStyle: TimeLineItemStyle) -> UIView {
        let positionView = DottedTimeLineIndicatorView(style: itemStyle, withAutoLayout: true)
        positionView.dotOffset = dotOffset
        return positionView
    }

    public func updatedHeight(for textHeight: CGFloat) -> (height: CGFloat, verticalOffset: CGFloat) {
        let (height, dotOffset) = calculateHeight(for: textHeight)
        let verticalOffset = dotOffset - DottedTimeLineIndicatorProvider.textVerticalMargin

        return (
            height: height,
            verticalOffset: verticalOffset
        )
    }

    private func calculateHeight(for textHeight: CGFloat) -> (height: CGFloat, dotOffset: CGFloat) {
        // We have to calculate with the top and bottom margins so we're adding those
        // to the text height.
        var newTextHeight = textHeight + 2 * DottedTimeLineIndicatorProvider.textVerticalMargin
        newTextHeight += dotOffset - upperHalf
        let offset = DottedTimeLineIndicatorView.dotSpacing + DottedTimeLineIndicatorView.fillingDotSize

        var bottomY = dotOffset
            + DottedTimeLineIndicatorView.indicatorDotSize / 2
            + DottedTimeLineIndicatorView.dotSpacing
            + DottedTimeLineIndicatorView.fillingDotSize / 2

        while bottomY <= newTextHeight {
            bottomY += offset
        }

        newTextHeight += bottomY - newTextHeight

        return (
            height: newTextHeight,
            dotOffset: dotOffset
        )
    }
}
