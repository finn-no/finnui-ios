//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI
import UIKit

final class ExploreDetailDemoView: UIView {
    private let viewModel = ExploreDetailViewModel(
        title: "Barnerom",
        subtitle: "KOLLEKSJON",
        imageUrl: nil,
        sections: [
            .init(title: "Gå dypere til verks", items: .collections([
                ExploreCollectionViewModel(title: "Bord"),
                ExploreCollectionViewModel(title: "Seng"),
                ExploreCollectionViewModel(title: "Stellebord"),
                ExploreCollectionViewModel(title: "Stol"),
                ExploreCollectionViewModel(title: "Oppbevaring"),
                ExploreCollectionViewModel(title: "Dekorasjon")
            ])),
            .init(title: "Eller rett på sak", items: .ads([
                ExploreAdCellViewModel(
                    title: "Hjemmekontor: skjerm, mus, tastatur+",
                    location: "Oslo",
                    price: "850 kr",
                    time: "2 timer siden",
                    aspectRatio: 1
                ),
                ExploreAdCellViewModel(
                    title: "Ståbord for hjemmekontor",
                    location: "Oslo",
                    price: "4999 kr",
                    time: "2 timer siden",
                    aspectRatio: 1.33
                ),
                ExploreAdCellViewModel(
                    title: "Aarsland hyller til kontor/hjemmekontor",
                    location: "Oslo",
                    price: "500 kr",
                    time: "2 timer siden",
                    aspectRatio: 0.74
                ),
                ExploreAdCellViewModel(
                    title: "Pent brukt Microsoft Surface laptop",
                    location: "Oslo",
                    price: "4000 kr",
                    time: "2 timer siden",
                    aspectRatio: 1
                )
            ]))
        ]
    )

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
    func exploreDetailView(_ view: ExploreDetailView, didScrollWithOffset: CGPoint) {}
}
