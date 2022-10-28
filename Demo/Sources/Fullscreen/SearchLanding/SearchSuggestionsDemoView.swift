import FinnUI
import FinniversKit

class SearchSuggestionsDemoView: UIView, Tweakable {

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Search suggestions", description: "With location permission cell") { [weak self] in
            self?.searchLandingView.configure(with: .suggestions(withLocationPermission: true), delegate: self)
        },
        TweakingOption(title: "Search suggestions", description: "Without location permission cell") { [weak self] in
            self?.searchLandingView.configure(with: .suggestions(), delegate: self)
        },
        TweakingOption(title: "Search landingpage", description: "With location permission cell") { [weak self] in
            self?.searchLandingView.configure(with: .landingPage(withLocationPermission: true), delegate: self)
        },
        TweakingOption(title: "Search landingpage", description: "Without location permission cell") { [weak self] in
            self?.searchLandingView.configure(with: .landingPage(), delegate: self)
        }
    ]

    private lazy var searchLandingView = FrontpageSearchView(withAutoLayout: true, delegate: self, remoteImageViewDataSource: self)

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

// MARK: - Search Landing View Delegate
extension SearchSuggestionsDemoView: FrontpageSearchViewDelegate {
    func frontpageSearchView(didSelectFavoriteButton button: UIButton, forAdWithId: Int, cell: FrontpageSearchImageResultCollectionViewCell) {
        print("🔥🔥🔥🔥 \(#function)")
    }

    func frontpageSearchViewDidScroll() {
        print("🔥🔥🔥🔥 \(#function)")
    }

    func frontpageSearchView(_ view: FinnUI.FrontpageSearchView, didSelectResultAt indexPath: IndexPath, uuid: UUID) {
        print("🔥🔥🔥🔥 indexPath = \(indexPath)")
        print("🔥🔥🔥🔥 \(#function)")
    }

    func frontpageSearchView(didTapEnableLocationButton button: UIButton) {
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
