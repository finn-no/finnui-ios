//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI
import FinniversKit
import UIKit

final class TagCloudGridDemoView: UIView {
    private lazy var view: TagCloudGridView = {
        let view = TagCloudGridView(withAutoLayout: true)
        view.delegate = self
        view.remoteImageViewDataSource = self
        return view
    }()

    private var items: [TagCloudCellViewModel] = {
        return [
            TagCloudCellViewModel(text: "Brettspill", iconUrl: "displayTypeGrid", backgroundColor: .systemPink, foregroundColor: .white),
            TagCloudCellViewModel(text: "Foto", iconUrl: nil, backgroundColor: .systemOrange, foregroundColor: .white),
            TagCloudCellViewModel(text: "Gaming", iconUrl: nil, backgroundColor: .systemRed, foregroundColor: .white),
            TagCloudCellViewModel(text: "Hjemmekontor", iconUrl: nil, backgroundColor: .systemGreen, foregroundColor: .white),
            TagCloudCellViewModel(text: "Planter", iconUrl: nil, backgroundColor: .systemBlue, foregroundColor: .white),
            TagCloudCellViewModel(text: "Puslespill", iconUrl: nil, backgroundColor: .systemPurple, foregroundColor: .white),
            TagCloudCellViewModel(text: "Spillkonsoller", iconUrl: nil, backgroundColor: .systemTeal, foregroundColor: .white),
            TagCloudCellViewModel(text: "Studentlivet", iconUrl: "displayTypeGrid", backgroundColor: .systemBlue, foregroundColor: .white),
            TagCloudCellViewModel(text: "Søte dyr", iconUrl: nil, backgroundColor: .systemOrange, foregroundColor: .white),
            TagCloudCellViewModel(text: "Vintersport", iconUrl: nil, backgroundColor: .systemPurple, foregroundColor: .white)
        ]
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(view)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor),
            view.heightAnchor.constraint(equalToConstant: TagCloudGridView.height(for: items))
        ])

        view.configure(withItems: items)
    }
}

// MARK: - SearchFilterTagsViewDelegate

extension TagCloudGridDemoView: TagCloudGridViewDelegate {
    func tagCloudGridView(_ view: TagCloudGridView, didSelectItem item: TagCloudCellViewModel, at indexPath: IndexPath) {
        print("Selected item at index \(indexPath.item)")
    }
}

// MARK: - RemoteImageViewDataSource

extension TagCloudGridDemoView: RemoteImageViewDataSource {
    func remoteImageView(
        _ view: RemoteImageView,
        loadImageWithPath imagePath: String,
        imageWidth: CGFloat,
        completion: @escaping ((UIImage?) -> Void)
    ) {
        completion(UIImage(named: imagePath))
    }

    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        return nil
    }
}
