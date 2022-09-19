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

    /*
    private lazy var searchSuggestionsView: SearchSuggestionsView = {
        let view = SearchSuggestionsView(withAutoLayout: true)
        view.delegate = self
        return view
    }()*/

    private lazy var searchLandingView = SearchLandingView(withAutoLayout: true, delegate: self, remoteImageViewDataSource: self)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        tweakingOptions.last?.action?()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(searchLandingView)
        searchLandingView.fillInSuperview()
    }
}

/*
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
}*/

// MARK: - Search Landing View Delegate
extension SearchSuggestionsDemoView: SearchLandingViewDelegate {
    func searchLandingView(_ view: FinnUI.SearchLandingView, didSelectResultAt indexPath: IndexPath, uuid: UUID) {
        print("🔥🔥🔥🔥 indexPath = \(indexPath)")
        print("🔥🔥🔥🔥 \(#function)")
    }

    func searchLandingView(_ view: SearchLandingView, didSelectResultAt indexPath: IndexPath) {
        print("🔥🔥🔥🔥 indexPath = \(indexPath)")
        print("🔥🔥🔥🔥 \(#function)")
    }

    func searchLandingView(didSelectFavoriteButton button: UIButton, forAdWithId adId: String) {
        print("🔥🔥🔥🔥 forAdWithId = \(adId)")
        print("🔥🔥🔥🔥 \(#function)")
    }


}


// MARK: - RemoteImageViewDataSource

extension SearchSuggestionsDemoView: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        nil
    }

    func remoteImageView(
        _ view: RemoteImageView,
        loadImageWithPath imagePath: String,
        imageWidth: CGFloat,
        completion: @escaping (UIImage?) -> Void
    ) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

        // Demo code only.
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            usleep(50_000)
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }

        task.resume()
    }

    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {
    }
}
