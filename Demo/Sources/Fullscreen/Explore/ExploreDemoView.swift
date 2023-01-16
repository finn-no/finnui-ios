//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI
import FinniversKit
import UIKit

final class ExploreDemoView: UIView {
    private let sections: [ExploreView.Section] = [
        .main(ExploreSectionViewModel(layout: .tagCloud, title: "Utvalgte kategorier", items: [
            ExploreCollectionViewModel(title: "Fashion"),
            ExploreCollectionViewModel(title: "Hjemmekontor"),
            ExploreCollectionViewModel(title: "Foto"),
            ExploreCollectionViewModel(title: "Brettspill"),
            ExploreCollectionViewModel(title: "Gaming"),
            ExploreCollectionViewModel(title: "Planter"),
            ExploreCollectionViewModel(title: "Puslespill"),
            ExploreCollectionViewModel(title: "Spillkonsoller"),
            ExploreCollectionViewModel(title: "Studentlivet"),
            ExploreCollectionViewModel(title: "Søte dyr"),
            ExploreCollectionViewModel(title: "Vintersport")
        ])),
        .main(ExploreSectionViewModel(layout: .twoRowsGrid, title: "Interiør og møbler", items: [
            ExploreCollectionViewModel(title: "Nordisk"),
            ExploreCollectionViewModel(title: "Planter"),
            ExploreCollectionViewModel(title: "Pastel"),
            ExploreCollectionViewModel(title: "Bauhaus"),
            ExploreCollectionViewModel(title: "Lamper"),
            ExploreCollectionViewModel(title: "Eklektisk"),
        ])),
        .main(ExploreSectionViewModel(layout: .hero, title: "Sommeren er her", items: [
            ExploreCollectionViewModel(title: "Åpne balkongen"),
            ExploreCollectionViewModel(title: "Balkongmøbler"),
            ExploreCollectionViewModel(title: "Plantekasser")
        ])),
        .main(ExploreSectionViewModel(layout: .squares, title: "Fashion og klær", items: [
            ExploreCollectionViewModel(title: "Herre"),
            ExploreCollectionViewModel(title: "Dame"),
            ExploreCollectionViewModel(title: "Barn")
        ])),
        .main(ExploreSectionViewModel(layout: .tagCloud, title: "Populære klesmerker", items: [
            ExploreCollectionViewModel(title: "Adidas"),
            ExploreCollectionViewModel(title: "Nike"),
            ExploreCollectionViewModel(title: "Puma"),
            ExploreCollectionViewModel(title: "Acne"),
            ExploreCollectionViewModel(title: "Tom Wood"),
            ExploreCollectionViewModel(title: "New Balance")
        ])),
        .main(ExploreSectionViewModel(layout: .squares, title: "Søte dyr", items: [
            ExploreCollectionViewModel(title: "Hunder"),
            ExploreCollectionViewModel(title: "Katter"),
            ExploreCollectionViewModel(title: "Fugler")
        ])),
        .main(ExploreSectionViewModel(layout: .hero, title: "Be creative", items: [
            ExploreCollectionViewModel(title: "Male"),
            ExploreCollectionViewModel(title: "Lære å sy"),
            ExploreCollectionViewModel(title: "Strikke"),
            ExploreCollectionViewModel(title: "Lage video"),
            ExploreCollectionViewModel(title: "Analoge kameraer")
        ])),
        .recommendations(RecommendationsViewModel(title: "Anbefalt", items: [
            ExploreRecommendationAdViewModel(imageSize: CGSize(width: 50, height: 100), title: "Malekost", isFavorite: false, scaleImageToFillView: true, favoriteButtonAccessibilityLabel: "Liker", id: "YOLO"),
            ExploreRecommendationAdViewModel(imageSize: CGSize(width: 200, height: 100), title: "Kostebrett", isFavorite: true, scaleImageToFillView: true, favoriteButtonAccessibilityLabel: "Liker", id: "YOLO1"),
            ExploreRecommendationAdViewModel(imageSize: CGSize(width: 50, height: 100), title: "Katt", isFavorite: false, scaleImageToFillView: true, favoriteButtonAccessibilityLabel: "Liker", id: "YOLO2"),
            ExploreRecommendationAdViewModel(imageSize: CGSize(width: 50, height: 100), title: "Hund", isFavorite: false, scaleImageToFillView: true, favoriteButtonAccessibilityLabel: "Liker", id: "YOLO3")
        ]))
    ]

    private lazy var view: ExploreView = {
        let view = ExploreView(withAutoLayout: true)
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
        view.configure(with: sections)
    }
}

// MARK: - ExploreViewDataSource

extension ExploreDemoView: ExploreViewDataSource {
    func exploreView(
        _ view: ExploreView,
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
            //usleep(50_000)
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

    func exploreView(_ view: ExploreView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}

// MARK: - ExploreViewDelegate

extension ExploreDemoView: ExploreViewDelegate {
    func exploreViewRecommendations(_ adRecommendationsGridView: FinnUI.ExploreView, didSelectItemAtIndex index: Int, withId: String) {
        print("🕵️‍♀️", #function)
    }

    func exploreViewRecommendations(_ adRecommendationsGridView: FinnUI.ExploreView, willDisplayItemAtIndex index: Int) {
        print("🕵️‍♀️", #function)
    }

    func exploreViewRecommendations(_ adRecommendationsGridView: FinnUI.ExploreView, didScrollInScrollView scrollView: UIScrollView) {
        print("🕵️‍♀️", #function)
    }

    func exploreViewRecommendations(_ adRecommendationsGridView: FinnUI.ExploreView, didSelectFavoriteButton button: UIButton, on cell: FinniversKit.StandardAdRecommendationCell, at index: Int) {
        print("🕵️‍♀️", #function)
    }

    func exploreViewDidRefresh(_ view: ExploreView) {
        print("Did refresh")
        view.configure(with: sections)
    }

    func exploreView(_ view: ExploreView, didSelectItem item: ExploreCollectionViewModel, at indexPath: IndexPath) {
        print("Selected item at indexPath: \(indexPath)")
    }
}
