import UIKit
import FinniversKit
import FinnUI

class RealestateSoldStateDemoView: UIView {
    private lazy var scrollView = UIScrollView(withAutoLayout: true)
    private lazy var realestateSoldStateView: RealestateSoldStateView = {
        let view = RealestateSoldStateView(withAutoLayout: true)
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        scrollView.alwaysBounceVertical = true

        addSubview(scrollView)
        scrollView.fillInSuperview()
        scrollView.addSubview(realestateSoldStateView)

        NSLayoutConstraint.activate([
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            realestateSoldStateView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            realestateSoldStateView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            realestateSoldStateView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            realestateSoldStateView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
    }
}
