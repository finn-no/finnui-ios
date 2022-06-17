import FinniversKit
import FinnUI

final class TimeLineDemoView: UIView {
    let timeLineView: TimeLineView

    override init(frame: CGRect) {
        let items = [
            TimeLineItem(title: "First asiodasi asd us a dasihdaihsdu asiu d da soidj asjd aosi dioa sod jsaidj asu duha ui dsashduha sid asd aso ditem"),
            TimeLineItem(title: "Second item"),
            TimeLineItem(title: "Third it asduhas udihasu dhuias d as dsesduah idu hasui duia sduas diaus usam"),
            TimeLineItem(title: "Fourth item"),
        ]
        self.timeLineView = TimeLineView(items: items, withAutoLayout: true)
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(timeLineView)

        NSLayoutConstraint.activate([
            timeLineView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingM),
            timeLineView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingM),
            timeLineView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingM)
        ])

        layoutIfNeeded()
    }
}
