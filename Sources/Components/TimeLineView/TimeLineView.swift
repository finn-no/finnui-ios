import FinniversKit
import UIKit

public final class TimeLineView: UIStackView {
    private var processedSubViews = false
    private let items: [TimeLineItem]
    private let itemIndicatorProvider: TimeLineIndicatorProvider

    public init(items: [TimeLineItem], itemIndicatorProvider: TimeLineIndicatorProvider, withAutoLayout: Bool = false) {
        self.items = items
        self.itemIndicatorProvider = itemIndicatorProvider
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        axis = .vertical

        for (index, item) in items.enumerated() {
            var itemStyle: TimeLineItemStyle {
                if items.count == 1 {
                    return .single
                } else if index == 0 {
                    return .starting
                } else if index == items.count - 1 {
                    return .final
                } else { return .middle }
            }
            let itemView = TimeLineItemView(
                withTitle: item.title,
                itemStyle: itemStyle,
                timeLineIndicatorProvider: itemIndicatorProvider,
                withAutoLayout: true
            )
            addArrangedSubview(itemView)
        }
    }

    public override func layoutSubviews() {
        arrangedSubviews.forEach {
            $0.layoutIfNeeded()
            $0.invalidateIntrinsicContentSize()
        }
    }
}

extension TimeLineView {
    public enum IndicatorStyle {
        case largeDots
        case largeDotsWithDottedLine
    }
}
