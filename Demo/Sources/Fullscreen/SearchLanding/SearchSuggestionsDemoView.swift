import FinnUI
import FinniversKit

class SearchSuggestionsDemoView: UIView, Tweakable {

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Search suggestions", description: "With location permission cell") { [weak self] in
            self?.searchLandingView.configure(with: .suggestions(withLocationPermission: true))
        },
        TweakingOption(title: "Search suggestions", description: "Without location permission cell") { [weak self] in
            self?.searchLandingView.configure(with: .suggestions())
        },
        TweakingOption(title: "Search landingpage", description: "With location permission cell") { [weak self] in
            self?.searchLandingView.configure(with: .landingPage(withLocationPermission: true))
        },
        TweakingOption(title: "Search landingpage", description: "Without location permission cell") { [weak self] in
            self?.searchLandingView.configure(with: .landingPage())
        }
    ]

    private lazy var searchSuggestionsView: SearchSuggestionsView = {
        let view = SearchSuggestionsView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private lazy var searchLandingView = SearchLandingView(withAutoLayout: true, delegate: self)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        tweakingOptions.first?.action?()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(searchLandingView)
        searchLandingView.fillInSuperview()
    }
}

// MARK: - SearchSuggestionsViewDelegate

extension SearchSuggestionsDemoView: SearchSuggestionsViewDelegate {
    func searchSuggestionsView(_ view: SearchSuggestionsView, didSelectResultAt indexPath: IndexPath) {
        print("🔥🔥🔥🔥 indexPath = \(indexPath)")
        print("🔥🔥🔥🔥 \(#function)")
    }

    func searchSuggestionsViewDidSelectViewMoreResults(_ view: SearchSuggestionsView) {
        print("🔥🔥🔥🔥 \(#function)")
    }

    func searchSuggestionsViewDidSelectLocationButton(_ view: SearchSuggestionsView) {
        print("🔥🔥🔥🔥 \(#function)")
    }

    func searchSuggestionsViewDidScroll() {
        print("🔥🔥🔥🔥 \(#function)")
    }
}

// MARK: - Search Landing View Delegate
extension SearchSuggestionsDemoView: SearchLandingViewDelegate {
    func searchLandingView(didSelectFavoriteButton button: UIButton, forAdWithId adId: String) {
        print("🔥🔥🔥🔥 forAdWithId = \(adId)")
        print("🔥🔥🔥🔥 \(#function)")
    }


}
