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
