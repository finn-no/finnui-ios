import UIKit
import FinniversKit
import FinnUI

class SearchDropdownGroupDemoView: UIView, Tweakable {

    // MARK: - Private properties

    private lazy var groupView: SearchDropdownGroupView = {
        let view = SearchDropdownGroupView(identifier: "uniqe-id", withAutoLayout: true)
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

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Recent searches", action: { [weak self] in
            self?.configureView(title: "Siste søk", buttonTitle: "Fjern alle", items: .recentSearches)
        }),
        TweakingOption(title: "Saved searches", action: { [weak self] in
            self?.configureView(title: "Lagrede søk", buttonTitle: "Se alle dine lagrede søk", items: .savedSearches)
        }),
        TweakingOption(title: "Recent searches", description: "No subtitles", action: { [weak self] in
            self?.configureView(title: "Siste søk", buttonTitle: "Fjern alle", items: .recentSearchesNoSubtitles)
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

        scrollView.addSubview(groupView)
        groupView.fillInSuperview()
        groupView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }

    // MARK: - Private methods

    private func configureView(title: String, buttonTitle: String? = nil, items: [SearchDropdownGroupItem]) {
        groupView.configure(title: title, buttonTitle: buttonTitle)
        groupView.configure(with: items, remoteImageViewDataSource: self)
    }
}

// MARK: - SearchDropdownGroupViewDelegate

extension SearchDropdownGroupDemoView: SearchDropdownGroupViewDelegate {
    func searchDropdownGroupViewDidSelectActionButton(_ view: SearchDropdownGroupView, withIdentifier identifier: String) {
        print("🔥🔥🔥🔥 Identifier: '\(identifier)' – ActionButton was selected")
    }

    func searchDropdownGroupView(_ view: SearchDropdownGroupView, withIdentifier identifier: String, didSelectItemAtIndex index: Int) {
        print("🔥🔥🔥🔥 Identifier: '\(identifier)' – GroupItem with index '\(index)' was selected")
    }

    func searchDropdownGroupView(
        _ view: SearchDropdownGroupView,
        withIdentifier identifier: String,
        didSelectRemoveButtonForItemAtIndex index: Int
    ) {
        print("🔥🔥🔥🔥 Identifier: '\(identifier)' – RemoveButton for GroupItem with index '\(index)' was selected")
    }
}

// MARK: - RemoteImageViewDataSource

extension SearchDropdownGroupDemoView: RemoteImageViewDataSource {
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

    static var recentSearchesNoSubtitles: [SearchDropdownGroupItem] {
        recentSearches.map {
            SearchDropdownGroupItem(
                title: $0.title,
                subtitle: nil,
                imageUrl: $0.imageUrl,
                titleColor: $0.titleColor,
                showDeleteButton: $0.showDeleteButton
            )
        }
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
