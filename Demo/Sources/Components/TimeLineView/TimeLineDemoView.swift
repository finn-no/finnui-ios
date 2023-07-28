import FinniversKit
import FinnUI
import DemoKit

final class TimeLineDemoView: UIView {
    let items = [
        TimeLineItem(title: "First asiodasi asd us a dasihdaihsdu asiu d da soidj asjd aosi dioa sod jsaidj asu duha ui dsashduha sid asd aso ditem"),
        TimeLineItem(title: "Second item"),
        TimeLineItem(title: "Third it asduhas udihasu dhuias d as dsesduah idu hasui duia sduas diaus usam"),
        TimeLineItem(title: "Fourth item"),
    ]

    var timeLineView: TimeLineView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(forTweakAt: 0)
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

        self.timeLineView = timeLineView
    }
}

// MARK: - TweakableDemo

extension TimeLineDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case withDottedLine
        case withSimpleIndicators
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .withDottedLine:
            let timeLineIndicatorProvider = DottedTimeLineIndicatorProvider(font: .caption)
            let timeLineView = TimeLineView(
                items: items,
                itemIndicatorProvider: timeLineIndicatorProvider,
                withAutoLayout: true
            )
            setup(with: timeLineView)
        case .withSimpleIndicators:
            let simpleIndicatorProvider = SimpleTimeLineIndicatorProvider(font: .caption)
            let timeLineView = TimeLineView(
                items: items,
                itemIndicatorProvider: simpleIndicatorProvider,
                withAutoLayout: true
            )
            setup(with: timeLineView)
        }
    }
}
