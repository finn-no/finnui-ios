import FinniversKit
import FinnUI

final class TimeLineDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "With dotted line", action: { [unowned self] in
            let timeLineIndicatorProvider = DottedTimeLineIndicatorProvider(font: .caption)
            let timeLineView = TimeLineView(
                items: items,
                itemIndicatorProvider: timeLineIndicatorProvider,
                withAutoLayout: true
            )
            setup(with: timeLineView)
        }),
        TweakingOption(title: "Just with simple indicators", action: { [unowned self] in
            let simpleIndicatorProvider = SimpleTimeLineIndicatorProvider(font: .caption)
            let timeLineView = TimeLineView(
                items: items,
                itemIndicatorProvider: simpleIndicatorProvider,
                withAutoLayout: true
            )
            setup(with: timeLineView)
        })
    ]

    let items = [
        TimeLineItem(title: "First asiodasi asd us a dasihdaihsdu asiu d da soidj asjd aosi dioa sod jsaidj asu duha ui dsashduha sid asd aso ditem"),
        TimeLineItem(title: "Second item"),
        TimeLineItem(title: "Third it asduhas udihasu dhuias d as dsesduah idu hasui duia sduas diaus usam"),
        TimeLineItem(title: "Fourth item"),
    ]

    var timeLineView: TimeLineView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        tweakingOptions.first?.action!()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup(with timeLineView: TimeLineView) {
        self.timeLineView?.removeFromSuperview()

        addSubview(timeLineView)

        NSLayoutConstraint.activate([
            timeLineView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingM),
            timeLineView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingM),
            timeLineView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingM)
        ])

        layoutIfNeeded()

        self.timeLineView = timeLineView
    }
}
