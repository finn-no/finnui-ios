import UIKit
import FinniversKit
import FinnUI
import DemoKit

class PopularSearchesDemoView: UIView {
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

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configure(forTweakAt: 0)
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

// MARK: - TweakableDemo

extension PopularSearchesDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, DemoKit.TweakingOption {
        case fiveSearches
        case fourSearches
        case oneSearch
        case differentLenghts
    }

    var dismissKind: DismissKind { .button }
    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any DemoKit.TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .fiveSearches:
            popularSearchesView.configure(with: ["Hund", "Katt", "Fugl", "Sykkelhjul", "Traktortilhenger"])
        case .fourSearches:
            popularSearchesView.configure(with: ["Hund", "Katt", "Fugl", "Sykkelhjul"])
        case .oneSearch:
            popularSearchesView.configure(with: ["Hund"])
        case .differentLenghts:
            popularSearchesView.configure(with: ["Båt", "Traktortilhenger", "Båt", "Traktortilhenger", "Båt", "Traktortilhenger", "Båt", "Traktortilhenger"])
        }
    }
}

// MARK: - PopularSearchesViewDelegate

extension PopularSearchesDemoView: PopularSearchesViewDelegate {
    func popularSearchesView(_ view: PopularSearchesView, didSelectItemAtIndex index: Int) {
        print("🔥🔥🔥🔥 Item at index '\(index)' was selected")
    }
}
