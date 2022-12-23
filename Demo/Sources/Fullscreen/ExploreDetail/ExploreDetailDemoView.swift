//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI
import UIKit

final class ExploreDetailDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Collection Detail", action: { [weak self] in
            self?.reload()
        })
    ]

    private var sections = [ExploreDetailSection]()
    private var favorites = Set<Int>()

    private lazy var view: ExploreDetailView = {
        let view = ExploreDetailView(dataSource: self, delegate: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(view)
        view.fillInSuperview()
        reload()
    }

    private func reload() {
        view.configure(with: .collectionDetail)

        syncFavorites()
        view.reloadSections()
    }

    private func syncFavorites() {
        sections = ExploreDetailSection.collectionDetailSections(favorites: favorites)
    }
}

// MARK: - ExploreViewDataSource

extension ExploreDetailDemoView: ExploreDetailViewDataSource {
    func sections(inExploreDetailView view: ExploreDetailView) -> [ExploreDetailSection] {
        sections
    }

    func exploreDetailView(
        _ view: ExploreDetailView,
        loadImageWithPath imagePath: String,
        imageWidth: CGFloat,
        completion: @escaping ((UIImage?) -> Void)
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

    func exploreDetailView(_ view: ExploreDetailView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}

// MARK: - ExploreDetailViewDelegate

extension ExploreDetailDemoView: ExploreDetailViewDelegate {
    func exploreDetailView(
        _ view: ExploreDetailView,
        didTapFavoriteButton button: UIButton,
        at indexPath: IndexPath,
        viewModel: ExploreAdCellViewModel
    ) {
        if favorites.contains(indexPath.item) {
            favorites.remove(indexPath.item)
        } else {
            favorites.insert(indexPath.item)
        }

        syncFavorites()
        view.updateFavoriteStatusForVisibleItems()
    }

    func exploreDetailView(
        _ view: ExploreDetailView,
        didSelectCollection collection: ExploreCollectionViewModel,
        at indexPath: IndexPath
    ) {
        print("Did select collection at \(indexPath)")
    }

    func exploreDetailView(_ view: ExploreDetailView, didSelectAd ad: ExploreAdCellViewModel, at indexPath: IndexPath) {
        print("Did select ad at \(indexPath)")
    }

    func exploreDetailView(_ view: ExploreDetailView, didScrollWithOffset: CGPoint) {}
}
