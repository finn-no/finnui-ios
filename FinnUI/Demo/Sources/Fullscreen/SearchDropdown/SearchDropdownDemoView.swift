import FinnUI
import FinniversKit
import DemoKit

final class SearchDropdownDemoView: UIView {
    private lazy var searchDropdownView: SearchDropdownView = {
        let view = SearchDropdownView(withAutoLayout: true)
        view.delegate = self
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
        searchDropdownView.configure(title: "Siste søk", buttonTitle: "Fjern alle", section: .recentSearches)
        searchDropdownView.configure(title: "Lagrede søk", buttonTitle: "Se alle dine lagrede søk", section: .savedSearches)
        searchDropdownView.configure(title: "Populært på FINN", section: .popularSearches)

        addSubview(scrollView)
        scrollView.fillInSuperview()

        scrollView.addSubview(searchDropdownView)
        searchDropdownView.fillInSuperview()
        searchDropdownView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }

    // MARK: - Private methods

    private func configure(recentSearches: Bool, savedSearches: Bool, popularSearches: Bool) {
        searchDropdownView.configure(
            recentSearches: recentSearches ? .recentSearches : [],
            savedSearches: savedSearches ? .savedSearches : [],
            popularSearches: popularSearches ? .popularSearches : [],
            remoteImageViewDataSource: self
        )
    }
}

// MARK: - TweakableDemo

extension SearchDropdownDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case recentSavedAndPopular
        case recentAndSaved
        case recentAndPopular
        case savedAndPopular
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .recentSavedAndPopular:
            configure(recentSearches: true, savedSearches: true, popularSearches: true)
        case .recentAndSaved:
            configure(recentSearches: true, savedSearches: true, popularSearches: false)
        case .recentAndPopular:
            configure(recentSearches: true, savedSearches: false, popularSearches: true)
        case .savedAndPopular:
            configure(recentSearches: false, savedSearches: true, popularSearches: true)
        }
    }
}

// MARK: - SearchDropdownViewDelegate

extension SearchDropdownDemoView: SearchDropdownViewDelegate {
    func searchDropdownView(_ view: SearchDropdownView, didSelectItemAtIndex index: Int, inSection section: SearchDropdownView.Section) {
        print("🔥🔥🔥🔥 Section: '\(section.rawValue)' – Item at index '\(index)' was selected")
    }

    func searchDropdownView(_ view: SearchDropdownView, didSelectRemoveButtonForItemAtIndex index: Int, inSection section: SearchDropdownView.Section) {
        print("🔥🔥🔥🔥 Section: '\(section.rawValue)' – RemoveButton for item at index '\(index)' was selected")
    }

    func searchDropdownView(_ view: SearchDropdownView, didSelectActionButtonForSection section: SearchDropdownView.Section) {
        print("🔥🔥🔥🔥 Section: '\(section.rawValue)' – ActionButton was selected")

    }
}

// MARK: - RemoteImageViewDataSource

extension SearchDropdownDemoView: RemoteImageViewDataSource {
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

// MARK: - Private extensions

private extension String {
    static var demoImageUrl: String {
        "https://2vmcwm4fqz4pi49cl1e4a036-wpengine.netdna-ssl.com/wp-content/uploads/2019/06/finn.no-ikon-300x300.png"
    }
}

private extension Array where Element == String {
    static var popularSearches: [String] {
        ["Hund", "Katt", "Fugl", "Sykkelhjul", "Traktortilhenger"]
    }
}

private extension Array where Element == SearchDropdownGroupItem {
    static var recentSearches: [SearchDropdownGroupItem] {
        [
            SearchDropdownGroupItem(
                title: "'Sofa'",
                subtitle: "Møbler og interiør",
                imageUrl: .demoImageUrl,
                titleColor: .textAction,
                showDeleteButton: true
            ),
            SearchDropdownGroupItem(
                title: "'Bolig til salgs', Oslo",
                subtitle: "Eiendom",
                imageUrl: .demoImageUrl,
                titleColor: .textAction,
                showDeleteButton: true
            ),
            SearchDropdownGroupItem(
                title: "Sykkel",
                subtitle: "Torget",
                imageUrl: .demoImageUrl,
                titleColor: .textAction,
                showDeleteButton: true
            ),
            SearchDropdownGroupItem(
                title: "'vintage kamera', 1500-4500kr",
                subtitle: "Elektronikk og hvitevarer",
                imageUrl: .demoImageUrl,
                titleColor: .textAction,
                showDeleteButton: true
            ),
        ]
    }

    static var savedSearches: [SearchDropdownGroupItem] {
        [
            SearchDropdownGroupItem(
                title: "Møbler i nabolaget",
                subtitle: "Torget",
                imageUrl: .demoImageUrl,
                showDeleteButton: false
            ),
            SearchDropdownGroupItem(
                title: "Hunder",
                subtitle: "Torget",
                imageUrl: .demoImageUrl,
                showDeleteButton: false
            ),
            SearchDropdownGroupItem(
                title: "Bolig til leie",
                subtitle: "Torget",
                imageUrl: .demoImageUrl,
                showDeleteButton: false
            )
        ]
    }
}
