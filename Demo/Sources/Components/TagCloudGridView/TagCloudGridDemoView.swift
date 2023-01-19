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

    private var items: [TagCloudCellViewModel] = [
        TagCloudCellViewModel(title: "Brettspill", iconUrl: "notifications"),
        TagCloudCellViewModel(title: "Foto", iconUrl: nil),
        TagCloudCellViewModel(title: "Gaming", iconUrl: nil),
        TagCloudCellViewModel(title: "Hjemmekontor", iconUrl: nil),
        TagCloudCellViewModel(title: "Planter", iconUrl: nil),
        TagCloudCellViewModel(title: "Puslespill", iconUrl: nil),
        TagCloudCellViewModel(title: "Spillkonsoller", iconUrl: nil),
        TagCloudCellViewModel(title: "Studentlivet", iconUrl: "notifications"),
        TagCloudCellViewModel(title: "Søte dyr", iconUrl: nil),
        TagCloudCellViewModel(title: "Vintersport", iconUrl: nil)
    ]

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
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
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
