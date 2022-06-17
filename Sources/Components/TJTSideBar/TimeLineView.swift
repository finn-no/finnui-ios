import FinniversKit
import UIKit

public final class TimeLineView: UIStackView {
    private var processedSubViews = false
    private let items: [TimeLineItem]

    public init(items: [TimeLineItem], withAutoLayout: Bool = false) {
        self.items = items
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
            var itemType: TimeLineItemView.ItemType {
                if index == 0 {
                    return .starting
                } else if index == items.count - 1 {
                    return .final
                } else { return .middle }
            }
            let itemView = TimeLineItemView(
                withTitle: item.title,
                type: itemType,
                withAutoLayout: true
            )
            addArrangedSubview(itemView)
        }
    }

    public override func layoutSubviews() {
        arrangedSubviews.forEach { $0.invalidateIntrinsicContentSize() }
    }
}
