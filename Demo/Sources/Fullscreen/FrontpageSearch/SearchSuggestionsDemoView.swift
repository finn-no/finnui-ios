import FinnUI
import FinniversKit
import DemoKit

class SearchSuggestionsDemoView: UIView {
    private lazy var searchLandingView = FrontpageSearchView(withAutoLayout: true, delegate: self, remoteImageViewDataSource: self)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configure(forTweakAt: 0)
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(searchLandingView)
        searchLandingView.fillInSuperview()
    }
}

// MARK: - TweakableDemo

extension SearchSuggestionsDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case searchSuggestionsWithLocationPermissionCell
        case searchSuggestionsWithoutLocationPermissionCell
        case searchLandingpageWithLocationPermissionCell
        case searchLandingpageWithoutLocationPermissionCell
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .searchSuggestionsWithLocationPermissionCell:
            searchLandingView.configure(with: .suggestions(withLocationPermission: true))
        case .searchSuggestionsWithoutLocationPermissionCell:
            searchLandingView.configure(with: .suggestions())
        case .searchLandingpageWithLocationPermissionCell:
            searchLandingView.configure(with: .landingPage(withLocationPermission: true))
        case .searchLandingpageWithoutLocationPermissionCell:
            searchLandingView.configure(with: .landingPage())
        }
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
