import UIKit
import FinniversKit
import FinnUI

class PopularSearchesDemoView: UIView, Tweakable {
    private lazy var popularSearchesView: PopularSearchesView = {
        let view = PopularSearchesView(withAutoLayout: true)
        view.delegate = self
        view.configure(title: "Populære søk")
        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.backgroundColor = .bgTertiary
        scrollView.alwaysBounceVertical = true
        scrollView.delaysContentTouches = false
        return scrollView
    }()

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "5 searches", action: { [weak self] in
            self?.popularSearchesView.configure(with: ["Hund", "Katt", "Fugl", "Sykkelhjul", "Traktortilhenger"])
        }),
        TweakingOption(title: "4 searches", action: { [weak self] in
            self?.popularSearchesView.configure(with: ["Hund", "Katt", "Fugl", "Sykkelhjul"])
        }),
        TweakingOption(title: "1 search", action: { [weak self] in
            self?.popularSearchesView.configure(with: ["Hund"])
        }),
    ]

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        tweakingOptions.first?.action?()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(scrollView)
        scrollView.fillInSuperview()

        scrollView.addSubview(popularSearchesView)
        popularSearchesView.fillInSuperview()
        popularSearchesView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        layoutIfNeeded()
    }
}

extension PopularSearchesDemoView: PopularSearchesViewDelegate {
    func popularSearchesView(_ view: PopularSearchesView, didSelectItemAtIndex index: Int) {
        print("🔥🔥🔥🔥 Item at index '\(index)' was selected")
    }
}
