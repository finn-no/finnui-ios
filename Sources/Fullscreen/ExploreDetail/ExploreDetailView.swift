//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

// MARK: - Protocols

public protocol ExploreDetailViewDelegate: AnyObject {
    func exploreDetailView(_ view: ExploreDetailView, didScrollWithOffset: CGPoint)
    func exploreDetailView(
        _ view: ExploreDetailView,
        didTapFavoriteButton button: UIButton,
        at indexPath: IndexPath,
        viewModel: ExploreAdCellViewModel
    )
    func exploreDetailView(
        _ view: ExploreDetailView,
        didSelectCollection collection: ExploreCollectionViewModel,
        at indexPath: IndexPath
    )
    func exploreDetailView(
        _ view: ExploreDetailView,
        didSelectAd ad: ExploreAdCellViewModel,
        at indexPath: IndexPath
    )
}

public protocol ExploreDetailViewDataSource: AnyObject {
    func exploreDetailView(
        _ view: ExploreDetailView,
        loadImageWithPath imagePath: String,
        imageWidth: CGFloat,
        completion: @escaping ((UIImage?) -> Void)
    )
    func exploreDetailView(
        _ view: ExploreDetailView,
        cancelLoadingImageWithPath imagePath: String,
        imageWidth: CGFloat
    )
    func sections(inExploreDetailView view: ExploreDetailView) -> [ExploreDetailSection]
}

// MARK: - View

public final class ExploreDetailView: UIView {

    // MARK: - Public properties

    public weak var delegate: ExploreDetailViewDelegate?
    public weak var dataSource: ExploreDetailViewDataSource?

    // MARK: - Private properties

    private typealias Section = ExploreDetailSection
    private var sections: [Section] {
        dataSource?.sections(inExploreDetailView: self) ?? []
    }
    private let imageCache = ImageMemoryCache()
    private let layoutBuilder = ExploreDetailLayoutBuilder(elementKind: UICollectionView.elementKindSectionHeader)
    private let heroViewHeight: CGFloat = 220

    // MARK: - Subviews

    private lazy var heroView = ExploreDetailHeroView(withAutoLayout: true)

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: bounds,
            collectionViewLayout: UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
                guard let self = self, let section = self.sections[safe: sectionIndex] else { return nil }
                return self.layoutBuilder.collectionLayoutSection(
                    for: section,
                    at: sectionIndex,
                    traitCollection: self.traitCollection
                )
            }
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.backgroundColor = .bgPrimary
        collectionView.contentInset.bottom = 100
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset.top = heroViewHeight
        collectionView.register(ExploreCollectionCell.self)
        collectionView.register(ExploreAdCell.self)
        collectionView.register(ExploreSectionHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
        return collectionView
    }()

    // MARK: - Other lazy properties

    private lazy var heroViewTopConstraint = heroView.topAnchor.constraint(equalTo: topAnchor)
    private lazy var heroViewHeightConstraint = heroView.heightAnchor.constraint(equalToConstant: heroViewHeight)

    private lazy var collectionDataSource: UICollectionViewDiffableDataSource<Section, Item> = {
        let dataSource = UICollectionViewDiffableDataSource<Section, Item>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                switch item {
                case .collection(let viewModel):
                    let cell = collectionView.dequeue(ExploreCollectionCell.self, for: indexPath)
                    cell.remoteImageViewDataSource = self
                    cell.configure(with: viewModel, kind: .narrow)
                    return cell
                case .ad(let viewModel):
                    let cell = collectionView.dequeue(ExploreAdCell.self, for: indexPath)
                    cell.delegate = self
                    cell.remoteImageViewDataSource = self
                    cell.configure(with: viewModel, indexPath: indexPath)
                    return cell
                }
            })

        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let section = self?.sections[safe: indexPath.section], let title = section.title else {
                return nil
            }

            let view = collectionView.dequeue(
                ExploreSectionHeaderView.self,
                for: indexPath,
                ofKind: UICollectionView.elementKindSectionHeader
            )
            view.configure(withText: title, font: section.headerFont)
            return view
        }

        return dataSource
    }()

    // MARK: - Init

    public init(dataSource: ExploreDetailViewDataSource, delegate: ExploreDetailViewDelegate) {
        self.dataSource = dataSource
        self.delegate = delegate

        super.init(frame: .zero)
        setup()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    public func configure(with viewModel: ExploreDetailViewModel) {
        heroView.configure(withTitle: viewModel.title, subtitle: viewModel.subtitle, imageUrl: viewModel.imageUrl)
    }

    public func reloadSections() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)

        for section in sections {
            switch section.items {
            case .collections(let collections):
                snapshot.appendItems(collections.map(Item.collection), toSection: section)
            case .ads(let ads):
                snapshot.appendItems(ads.map(Item.ad), toSection: section)
            }
        }

        collectionDataSource.apply(snapshot, animatingDifferences: true)
    }

    public func updateFavoriteStatusForVisibleItems() {
        for indexPath in collectionView.indexPathsForVisibleItems {
            guard indexPath.section < sections.count else {
                continue
            }

            let section = sections[indexPath.section]

            switch section.items {
            case .collections:
                break
            case .ads(let items):
                if let cell = collectionView.cellForItem(at: indexPath) as? ExploreAdCell, indexPath.item < items.count {
                    cell.isFavorite = items[indexPath.item].isFavorite
                }
            }
        }
    }

    private func setup() {
        backgroundColor = .bgPrimary
        addSubview(collectionView)
        addSubview(heroView)

        collectionView.fillInSuperview()

        NSLayoutConstraint.activate([
            heroViewTopConstraint,
            heroView.leadingAnchor.constraint(equalTo: leadingAnchor),
            heroView.trailingAnchor.constraint(equalTo: trailingAnchor),
            heroViewHeightConstraint
        ])

        heroView.remoteImageViewDataSource = self
    }
}

// MARK: - UICollectionViewDelegate

extension ExploreDetailView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = collectionDataSource.itemIdentifier(for: indexPath) else {
            return
        }

        switch item {
        case .collection(let viewModel):
            delegate?.exploreDetailView(self, didSelectCollection: viewModel, at: indexPath)
        case .ad(let viewModel):
            delegate?.exploreDetailView(self, didSelectAd: viewModel, at: indexPath)
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.exploreDetailView(self, didScrollWithOffset: scrollView.contentOffset)

        let offset = scrollView.contentOffset.y
        let inset = collectionView.contentInset.top

        guard offset <= 0 else {
            if heroViewTopConstraint.constant != -inset {
                heroViewTopConstraint.constant = -inset
                layoutIfNeeded(animated: false)
            }
            return
        }

        if abs(offset) >= inset {
            heroViewHeightConstraint.constant = abs(offset)
            heroViewTopConstraint.constant = 0
        } else {
            heroViewHeightConstraint.constant = inset
            heroViewTopConstraint.constant = -(inset + offset)
        }

        layoutIfNeeded(animated: false)
    }
}

// MARK: - SearchViewCellDelegate

extension ExploreDetailView: ExploreAdCellDelegate {
    func exploreAdCell(_ cell: ExploreAdCell, didTapFavoriteButton button: UIButton) {
        guard let indexPath = cell.indexPath, let viewModel = cell.viewModel else {
            return
        }
        delegate?.exploreDetailView(self, didTapFavoriteButton: button, at: indexPath, viewModel: viewModel)
    }
}

// MARK: - RemoteImageViewDataSource

extension ExploreDetailView: RemoteImageViewDataSource {
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
        dataSource?.exploreDetailView(self, loadImageWithPath: imagePath, imageWidth: imageWidth, completion: { [weak self] image in
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
        dataSource?.exploreDetailView(self, cancelLoadingImageWithPath: imagePath, imageWidth: imageWidth)
    }
}

// MARK: - Private extensions

private extension ExploreDetailView {
    enum Item: Hashable {
        case collection(ExploreCollectionViewModel)
        case ad(ExploreAdCellViewModel)
    }
}

private extension ExploreDetailSection {
    var headerFont: UIFont {
        switch items {
        case .collections:
            return .bodyStrong
        case .ads:
            return .title3Strong
        }
    }
}

private extension UIView {
    func layoutIfNeeded(animated: Bool) {
        if animated {
            layoutIfNeeded()
        } else {
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            layoutIfNeeded()
            CATransaction.commit()
        }
    }
}
