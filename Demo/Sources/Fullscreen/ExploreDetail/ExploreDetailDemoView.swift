//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI
import UIKit

final class ExploreDetailDemoView: UIView, Tweakable {
    private enum Kind {
        case collection
        case selectedCategory
    }

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Collection Detail", action: { [weak self] in
            self?.kind = .collection
            self?.reload()
        }),
        TweakingOption(title: "Selected Category Detail", action: { [weak self] in
            self?.kind = .selectedCategory
            self?.reload()
        })
    ]

    private var kind: Kind = .collection
    private var favorites = Set<Int>()

    private lazy var view: ExploreDetailView = {
        let view = ExploreDetailView(withAutoLayout: true)
        view.delegate = self
        view.dataSource = self
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

    func reload() {
        let viewModel: ExploreDetailViewModel = {
            switch kind {
            case .collection:
                return .collectionDetail(favorites: favorites)
            case .selectedCategory:
                return .selectedCategoryDetail(favorites: favorites)
            }
        }()

        view.configure(with: viewModel)
    }
}

// MARK: - ExploreViewDataSource

extension ExploreDetailDemoView: ExploreDetailViewDataSource {
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

// MARK: - ExploreViewDelegate

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

        reload()
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
