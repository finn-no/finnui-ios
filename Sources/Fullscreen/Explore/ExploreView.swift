//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

// MARK: - Protocols

public protocol ExploreViewDelegate: AnyObject {
    func exploreViewDidRefresh(_ view: ExploreView)
    func exploreView(_ view: ExploreView, didSelectItem item: ExploreCollectionViewModel, at indexPath: IndexPath)
}

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

    // MARK: - Public properties

    public weak var delegate: ExploreViewDelegate?
    public weak var dataSource: ExploreViewDataSource?

    // MARK: - Private properties

    private var sections = [ExploreSectionViewModel]()
    private let imageCache = ImageMemoryCache()
    private let layoutBuilder = ExploreLayoutBuilder(elementKind: UICollectionView.elementKindSectionHeader)

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: bounds,
            collectionViewLayout: UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
                guard let self = self, let section = self.sections[safe: sectionIndex] else { return nil }
                return self.layoutBuilder.collectionLayoutSection(for: section)
            }
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.backgroundColor = .bgPrimary
        collectionView.contentInset.bottom = .spacingXL
        collectionView.register(ExploreCollectionCell.self)
        collectionView.register(ExploreTagCloudGridCell.self)
        collectionView.register(ExploreBrazeBannerCell.self)
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
                guard let self = self else { return UICollectionViewCell() }

                switch item {
                case .regular(let viewModel, let cellKind):
                    let cell = collectionView.dequeue(ExploreCollectionCell.self, for: indexPath)
                    cell.remoteImageViewDataSource = self
                    cell.configure(with: viewModel, kind: cellKind)
                    return cell
                case .tagCloud(let viewModels):
                    let cell = collectionView.dequeue(ExploreTagCloudGridCell.self, for: indexPath)
                    cell.gridView.tag = indexPath.section
                    cell.gridView.delegate = self
                    cell.gridView.remoteImageViewDataSource = self
                    cell.gridView.configure(withItems: viewModels)
                    return cell
                case .brazeBanner(let viewModel):
                    guard let banner = viewModel.banner else { return UICollectionViewCell() }
                    let cell = collectionView.dequeue(ExploreBrazeBannerCell.self, for: indexPath)
                    cell.configure(banner: banner)
                    return cell
                }
            })

        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let section = self?.sections[safe: indexPath.section], let title = section.title else { return nil }
            let view = collectionView.dequeue(
                ExploreSectionHeaderView.self,
                for: indexPath,
                ofKind: UICollectionView.elementKindSectionHeader
            )
            view.configure(withText: title)
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

    public func configure(with sections: [ExploreSectionViewModel]) {
        self.sections = sections

        var snapshot = NSDiffableDataSourceSnapshot<ExploreSectionViewModel, Item>()
        snapshot.appendSections(sections)

        for section in sections {
            switch section.layout {
            case .hero, .squares, .twoRowsGrid:
                let items = section.items.map {
                    Item.regular($0, section.layout == .hero ? .big : .regular)
                }
                snapshot.appendItems(items, toSection: section)
            case .tagCloud:
                let items = section.items.map {
                    TagCloudCellViewModel(title: $0.title, iconUrl: $0.iconUrl)
                }
                snapshot.appendItems([Item.tagCloud(items)], toSection: section)
            case .banner:
                let item = section.items.map {
                    ExploreCollectionViewModel(title: "braze", banner: $0.banner)
                }
                snapshot.appendItems([Item.brazeBanner(item.first!)], toSection: section)
            }
        }

        refreshControl.endRefreshing()

        if #available(iOS 16, *) {
            // animation added due to dismissable promotion banner
            collectionViewDataSource.apply(snapshot, animatingDifferences: true)
        } else if #available(iOS 15.0, *) {
            // struggles to correctly update the images in iOS 15 when using apply, so we have to force the whole collectionView to update
            collectionViewDataSource.applySnapshotUsingReloadData(snapshot)
        } else {
            collectionViewDataSource.apply(snapshot, animatingDifferences: false)
        }
    }

    private func setup() {
        addSubview(collectionView)
        collectionView.fillInSuperview()
    }

    // MARK: - Actions

    @objc private func onRefresh() {
        delegate?.exploreViewDidRefresh(self)
    }
}

// MARK: - UICollectionViewDelegate

extension ExploreView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.item]
        delegate?.exploreView(self, didSelectItem: item, at: indexPath)
    }
}

// MARK: - TagCloudGridViewDelegate

extension ExploreView: TagCloudGridViewDelegate {
    public func tagCloudGridView(_ view: TagCloudGridView, didSelectItem item: TagCloudCellViewModel, at indexPath: IndexPath) {
        let indexPath = IndexPath(item: indexPath.item, section: view.tag)
        let item = sections[indexPath.section].items[indexPath.item]
        delegate?.exploreView(self, didSelectItem: item, at: indexPath)
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
    case regular(ExploreCollectionViewModel, ExploreCollectionCell.Kind)
    case tagCloud([TagCloudCellViewModel])
    case brazeBanner(ExploreCollectionViewModel)
}
