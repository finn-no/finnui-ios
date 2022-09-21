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
    private let itemStyle: TimeLineItemStyle
    private let titleLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()

    private let positionLeftInset: CGFloat = .spacingXS
    private let positionAndLabelSpacing: CGFloat = .spacingXS + .spacingS
    private lazy var titleTopConstraint: NSLayoutConstraint = {
        titleLabel.topAnchor.constraint(equalTo: topAnchor)
    }()

    private let timeLineIndicatorProvider: TimeLineIndicatorProvider

    init(
        withTitle title: String,
        itemStyle: TimeLineItemStyle,
        timeLineIndicatorProvider: TimeLineIndicatorProvider,
        withAutoLayout: Bool = false
    ) {
        self.title = title
        self.itemStyle = itemStyle
        self.timeLineIndicatorProvider = timeLineIndicatorProvider
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        let indicatorView = timeLineIndicatorProvider.createView(withStyle: itemStyle)
        addSubview(indicatorView)

        NSLayoutConstraint.activate([
            indicatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: positionLeftInset),
            indicatorView.topAnchor.constraint(equalTo: topAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        indicatorView.setContentCompressionResistancePriority(.required, for: .horizontal)
        indicatorView.setContentHuggingPriority(.required, for: .horizontal)

        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: indicatorView.trailingAnchor, constant: positionAndLabelSpacing),
            titleTopConstraint,
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        titleLabel.text = title
    }

    override var intrinsicContentSize: CGSize {
        let availableWidth
        = bounds.width
        - positionLeftInset
        - timeLineIndicatorProvider.width
        - positionAndLabelSpacing

        let currentTextHeight = title.height(withConstrainedWidth: availableWidth, font: titleLabel.font)
        let (updatedHeight, verticalOffset) = timeLineIndicatorProvider.updatedHeight(for: currentTextHeight)
        titleTopConstraint.constant = verticalOffset

        return CGSize(
            width: UIView.noIntrinsicMetric,
            height: updatedHeight
        )
    }
}
