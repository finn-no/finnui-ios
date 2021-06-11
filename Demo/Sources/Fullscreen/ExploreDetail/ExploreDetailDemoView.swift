//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI
import UIKit

final class ExploreDetailDemoView: UIView {
    private let viewModel = ExploreDetailViewModel(
        title: "Skjorter",
        subtitle: "KOLLEKSJON",
        imageUrl: nil,
        sections: [
            .init(title: "", items: .collections([
                ExploreCollectionViewModel(title: "T-shirts"),
                ExploreCollectionViewModel(title: "Planter")
            ])),
            .init(title: "", items: .ads([
                ExploreAdCellViewModel(title: "", location: "", price: "", time: "", aspectRatio: nil)
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
