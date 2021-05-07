import FinnUI
import FinniversKit

class SearchSuggestionsDemoView: UIView, Tweakable {

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Search suggestions") { [weak self] in
            self?.searchSuggestionsView.configure(with: .suggestions)
        },
        TweakingOption(title: "Search landingpage") { [weak self] in
            self?.searchSuggestionsView.configure(with: .landingPage)
        }
    ]

    private lazy var searchSuggestionsView: SearchSuggestionsView = {
        let view = SearchSuggestionsView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        tweakingOptions.first?.action?()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(searchSuggestionsView)
        searchSuggestionsView.fillInSuperview()
    }
}

// MARK: - SearchSuggestionsViewDelegate

extension SearchSuggestionsDemoView: SearchSuggestionsViewDelegate {
    func searchSuggestionsView(_ view: SearchSuggestionsView, didSelectResultAt indexPath: IndexPath) {
        print("🔥🔥🔥🔥 \(#function)")
    }

    func searchSuggestionsViewDidSelectViewMoreResults(_ view: SearchSuggestionsView) {
        print("🔥🔥🔥🔥 \(#function)")
    }
}
