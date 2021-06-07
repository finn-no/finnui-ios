//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

// MARK: - Protocols

public protocol ExploreViewDelegate: AnyObject {}

public protocol ExploreViewDataSource: AnyObject {
    func exploreView(
        _ view: ExploreView,
        loadImageWithPath imagePath: String,
        imageWidth: CGFloat,
        completion: @escaping ((UIImage?) -> Void)
    )
    func exploreView(
        _ view: ExploreView,
        cancelLoadingImageWithPath imagePath: String,
        imageWidth: CGFloat
    )
}

// MARK: - View

public final class ExploreView: UIView {
    public weak var delegate: ExploreViewDelegate?
    public weak var dataSource: ExploreViewDataSource?
    private let imageCache = ImageMemoryCache()
    private let layoutBuilder = ExploreLayoutBuilder(elementKind: UICollectionView.elementKindSectionHeader)

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: bounds,
            collectionViewLayout: layoutBuilder.collectionViewLayout
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.backgroundColor = .bgPrimary
        collectionView.contentInset.bottom = .spacingXL
        collectionView.register(ExploreCollectionCell.self)
        collectionView.register(ExploreSectionHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.refreshControl = refreshControl
        return collectionView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        return refreshControl
    }()

    // MARK: - Data

    @objc private func onRefresh() {

    }
}

// MARK: - UICollectionViewDelegate

extension ExploreView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {}
}

// MARK: - RemoteImageViewDataSource

extension ExploreView: RemoteImageViewDataSource {
    public func remoteImageView(
        _ view: RemoteImageView,
        cachedImageWithPath imagePath: String,
        imageWidth: CGFloat
    ) -> UIImage? {
        imageCache.image(forKey: imagePath)
    }

    public func remoteImageView(
        _ view: RemoteImageView,
        loadImageWithPath imagePath: String,
        imageWidth: CGFloat,
        completion: @escaping ((UIImage?) -> Void)
    ) {
        dataSource?.exploreView(self, loadImageWithPath: imagePath, imageWidth: imageWidth, completion: { [weak self] image in
            if let image = image {
                self?.imageCache.add(image, forKey: imagePath)
            }
            completion(image)
        })
    }

    public func remoteImageView(
        _ view: RemoteImageView,
        cancelLoadingImageWithPath imagePath: String,
        imageWidth: CGFloat
    ) {
        dataSource?.exploreView(self, cancelLoadingImageWithPath: imagePath, imageWidth: imageWidth)
    }
}
