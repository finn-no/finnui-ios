//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

// MARK: - Protocols

public protocol ExploreViewDelegate: AnyObject {
    func exploreViewDidRefresh(_ view: ExploreView)
    func exploreView(_ view: ExploreView, didSelectItem item: ExploreCollectionViewModel, at indexPath: IndexPath)
    func exploreViewRecommendations(_ adRecommendationsGridView: ExploreView, didSelectRecommendationItemAtIndex index: Int, withId: String)
    func exploreViewRecommendations(_ adRecommendationsGridView: ExploreView, willDisplayRecommendationItemAtIndex index: Int)
    func exploreViewRecommendations(_ adRecommendationsGridView: ExploreView, didSelectFavoriteButton button: UIButton, on cell: AdRecommendationCell, at index: Int)
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

public protocol ExploreViewRecommendationsDatasource: AnyObject {
    func exploreViewRecommendations(_ exploreView: ExploreView, cellClassesIn collectionView: UICollectionView) -> [UICollectionViewCell.Type]
    func exploreViewRecommendations(_ exploreView: ExploreView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

public struct ExploreViewModel {
    public init(
        exploreSections: [ExploreSectionViewModel],
        recommendationsTitle: String,
        recommendationItems: [ExploreRecommendationAdViewModel])
    {
        self.exploreSections = exploreSections
        self.recommendationsTitle = recommendationsTitle
        self.recommendationItems = recommendationItems
    }

    public let exploreSections: [ExploreSectionViewModel]
    public let recommendationsTitle: String
    public let recommendationItems: [ExploreRecommendationAdViewModel]
}

// MARK: - View

public final class ExploreView: UIView {

    // MARK: - Public properties

    public weak var delegate: ExploreViewDelegate?
    public weak var dataSource: ExploreViewDataSource?
    private weak var recommendationsDataSource: ExploreViewRecommendationsDatasource?

    // MARK: - Private properties
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private lazy var collectionViewDataSource: DataSource = configureCollectionViewDataSource()

    private var sections = [Section]()
    private var exploreSections = [ExploreSectionViewModel]()
    private(set) var recommendationsSection = [ExploreRecommendationAdViewModel]()
    private(set) var recommendationsSectionTitle: String?
    private let imageCache = ImageMemoryCache()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: bounds,
            collectionViewLayout: UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
                guard let self = self, let section = self.sections[safe: sectionIndex] else { return nil }
                return self.collectionLayoutSection(for: section)
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

    private func configureCollectionViewDataSource() -> DataSource {
        let dataSource = DataSource(
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
                    let cell = collectionView.dequeue(ExploreBrazeBannerCell.self, for: indexPath)
                    cell.configure(banner: viewModel.brazePromo)
                    return cell
                case .recommendation(_):
                    let cell = self.recommendationsDataSource?.exploreViewRecommendations(self, collectionView: collectionView, cellForItemAt: indexPath)
                    return cell
                }
            })

        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let section = self?.sections[safe: indexPath.section] else { return nil }
            let view = collectionView.dequeue(
                ExploreSectionHeaderView.self,
                for: indexPath,
                ofKind: UICollectionView.elementKindSectionHeader
            )
            switch section {
            case .main(let viewModel):
                guard let title = viewModel.title else { return nil }
                view.configure(withText: title)
            case .recommendations:
                guard let viewModel = self?.recommendationsSection[safe: indexPath.item] else { return nil }
                let title = viewModel.title
                view.configure(withText: title)
            }
            return view
        }

        return dataSource
    }

    // MARK: - Init

    public init(withAutoLayout: Bool, recommendationsDataSource: ExploreViewRecommendationsDatasource) {
        self.recommendationsDataSource = recommendationsDataSource
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    public func configure(with viewModel: ExploreViewModel) {
        self.sections = []
        self.exploreSections = []
        self.recommendationsSection = []
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        for exploreSection in viewModel.exploreSections {
            let section = Section.main(exploreSection)
            sections.append(section)
            snapshot.appendSections([section])
            exploreSections.append(exploreSection)
            switch exploreSection.layout {
            case .hero, .squares, .twoRowsGrid:
                let items = exploreSection.items.map {
                    Item.regular($0, exploreSection.layout == .hero ? .big : .regular)
                }
                snapshot.appendItems(items, toSection: section)
            case .tagCloud:
                let items = exploreSection.items.map {
                    TagCloudCellViewModel(title: $0.title, iconUrl: $0.iconUrl)
                }
                snapshot.appendItems([Item.tagCloud(items)], toSection: section)
            case .banner:
                guard
                    let item = exploreSection.items.first(where: {$0.banner != nil}),
                    let viewModel = item.banner
                else { return }
                let banner = BrazeBannerViewModel(brazePromo: viewModel)
                snapshot.appendItems([Item.brazeBanner(banner)], toSection: section)
            }
        }
        if !viewModel.recommendationItems.isEmpty {
            recommendationsSectionTitle = viewModel.recommendationsTitle
            let section = Section.recommendations
            sections.append(section)
            snapshot.appendSections([section])
            recommendationsSection = viewModel.recommendationItems
            let items = viewModel.recommendationItems.map {
                Item.recommendation($0.self)
            }
            snapshot.appendItems(items, toSection: section)
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
        let cellClasses = recommendationsDataSource?.exploreViewRecommendations(self, cellClassesIn: collectionView) ?? []

        cellClasses.forEach { cellClass in
            collectionView.register(cellClass)
        }
        addSubview(collectionView)
        collectionView.fillInSuperview()
    }

    // MARK: - Public methods for recommendation handling

    public func loadMoreRecommendations(recommendations: [ExploreRecommendationAdViewModel]) {
        var snapshot = collectionViewDataSource.snapshot()

        recommendationsSection = recommendations
        let items = recommendations.map(Item.recommendation)

        snapshot.appendItems(items, toSection: .recommendations)
        collectionViewDataSource.apply(snapshot, animatingDifferences: false)
    }

    // MARK: - Favorite button handling
    public func updateFavoriteStateForAd(id: String, at index: Int, isFavorite: Bool) {
        let item = recommendationsSection[index]
        item.isFavorite = isFavorite

        if let sectionIndex = sections.firstIndex(of: .recommendations) {
            let cell = collectionView.cellForItem(at: IndexPath(row: index, section: sectionIndex)) as? StandardAdRecommendationCell
            cell?.isFavorite = isFavorite
        }
    }

    // MARK: - Actions

    @objc private func onRefresh() {
        delegate?.exploreViewDidRefresh(self)
    }
}

// MARK: - UICollectionViewDelegate

extension ExploreView: UICollectionViewDelegate {
    // selection of brazeBanner items are handled by BrazePromotionView itself
    // selection in tagCloudGridView is handled in TagCloudGridViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = collectionViewDataSource.itemIdentifier(for: indexPath)
        switch item {
        case .recommendation(let viewModel):
            delegate?.exploreViewRecommendations(self, didSelectRecommendationItemAtIndex: indexPath.row, withId: viewModel.id)
        case .regular(let viewModel, _):
            delegate?.exploreView(self, didSelectItem: viewModel, at: indexPath)
        default:
            break
        }
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let item = collectionViewDataSource.itemIdentifier(for: indexPath)
        if case .recommendation = item {
            delegate?.exploreViewRecommendations(self, willDisplayRecommendationItemAtIndex: indexPath.row)
        }
    }
}

// MARK: - TagCloudGridViewDelegate

extension ExploreView: TagCloudGridViewDelegate {
    // tagCloudGridView is always in the main section and can be selected from the exploreSections array
    public func tagCloudGridView(_ view: TagCloudGridView, didSelectItem item: TagCloudCellViewModel, at indexPath: IndexPath) {
        let indexPath = IndexPath(item: indexPath.item, section: view.tag)
        let item = exploreSections[indexPath.section].items[indexPath.item]
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

// MARK: - Nested types
extension ExploreView {
    enum Item: Hashable {
        case regular(ExploreCollectionViewModel, ExploreCollectionCell.Kind)
        case tagCloud([TagCloudCellViewModel])
        case brazeBanner(BrazeBannerViewModel)
        case recommendation(ExploreRecommendationAdViewModel)
    }

    enum Section: Hashable {
        case main(ExploreSectionViewModel)
        case recommendations
    }
}

// MARK: - Extension AdRecommendationCellDelegate
extension ExploreView: AdRecommendationCellDelegate {
    public func adRecommendationCell(_ cell: AdRecommendationCell, didTapFavoriteButton button: UIButton) {
        guard let index = cell.index else { return }
        delegate?.exploreViewRecommendations(self, didSelectFavoriteButton: button, on: cell, at: index)
    }
}

