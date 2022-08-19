import UIKit

public enum TimeLineItemStyle {
    case single
    case starting
    case middle
    case final
}

public protocol TimeLineIndicatorProvider {
    var width: CGFloat { get }

    func createView(withStyle itemStyle: TimeLineItemStyle) -> UIView
    func updatedHeight(for textHeight: CGFloat) -> (height: CGFloat, verticalOffset: CGFloat)
}
