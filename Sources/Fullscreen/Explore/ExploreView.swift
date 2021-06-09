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
    private var sections = [ExploreSectionViewModel]()
    private let imageCache = ImageMemoryCache()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: bounds,
            collectionViewLayout: UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
                ExploreLayoutBuilder(
                    sections: self?.sections ?? [],
                    elementKind: UICollectionView.elementKindSectionHeader
                ).collectionLayoutSection(at: sectionIndex)
            }
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.backgroundColor = .bgPrimary
        collectionView.contentInset.bottom = .spacingXL
        collectionView.register(ExploreCollectionCell.self)
        collectionView.register(ExploreTagCloudGridCell.self)
        collectionView.register(ExploreSectionHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.refreshControl = refreshControl
        return collectionView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        return refreshControl
    }()

    private lazy var collectionViewDataSource: UICollectionViewDiffableDataSource<ExploreSectionViewModel, Item> = {
        let dataSource = UICollectionViewDiffableDataSource<ExploreSectionViewModel, Item>(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, item in
                guard let self = self else { return nil }

                switch item {
                case .regular(let viewModel):
                    let cell = collectionView.dequeue(ExploreCollectionCell.self, for: indexPath)
                    cell.configure(with: viewModel)
                    return cell
                case .tagCloud(let viewModels):
                    let cell = collectionView.dequeue(ExploreTagCloudGridCell.self, for: indexPath)
                    cell.gridView.delegate = self
                    cell.gridView.configure(withItems: viewModels)
                    return cell
                }
            })

        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else { return nil }
            let section = self.sections[indexPath.section]
            let view = collectionView.dequeue(
                ExploreSectionHeaderView.self,
                for: indexPath,
                ofKind: UICollectionView.elementKindSectionHeader
            )
            view.configure(withText: section.title)
            return view
        }

        return dataSource
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    public func configure(withSections sections: [ExploreSectionViewModel]) {
        self.sections = sections

        var snapshot = NSDiffableDataSourceSnapshot<ExploreSectionViewModel, Item>()
        snapshot.appendSections(sections)

        for section in sections {
            switch section.layout {
            case .hero, .squares, .twoRowsGrid:
                snapshot.appendItems(section.items.map(Item.regular), toSection: section)
            case .tagCloud:
                let items = section.items.map {
                    TagCloudCellViewModel(
                        title: $0.title,
                        iconUrl: $0.iconUrl,
                        backgroundColor: .primaryBlue,
                        foregroundColor: .white
                    )
                }
                snapshot.appendItems([Item.tagCloud(items)], toSection: section)
            }
        }

        collectionViewDataSource.apply(snapshot, animatingDifferences: false)
    }

    private func setup() {
        addSubview(collectionView)
        collectionView.fillInSuperview()
    }

    // MARK: - Actions

    @objc private func onRefresh() {

    }
}

// MARK: - UICollectionViewDelegate

extension ExploreView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {}
}

// MARK: - TagCloudGridViewDelegate

extension ExploreView: TagCloudGridViewDelegate {
    public func tagCloudGridView(_ view: TagCloudGridView, didSelectItem item: TagCloudCellViewModel, at indexPath: IndexPath) {

    }
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

// MARK: - Private types

private enum Item: Equatable, Hashable {
    case regular(ExploreCollectionViewModel)
    case tagCloud([TagCloudCellViewModel])
}
