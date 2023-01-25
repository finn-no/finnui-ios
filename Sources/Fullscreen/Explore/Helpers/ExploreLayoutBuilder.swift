//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

struct ExploreLayoutBuilder {
    let elementKind: String

    func collectionLayoutSection(for section: ExploreView.Section) -> NSCollectionLayoutSection {
        let layoutSection: NSCollectionLayoutSection
        var title: String? = nil
        switch section {
        case .main(let viewModel):
            title = viewModel.title
            layoutSection = {
                switch viewModel.layout {
                case .hero:
                    return .hero
                case .squares:
                    return .squares
                case .twoRowsGrid:
                    return .twoRowsGrid
                case .tagCloud:
                    let group = TagCloudGridView.collectionLayoutGroup(with: viewModel.items)
                    return NSCollectionLayoutSection(group: group)
                case .banner:
                    return .banner
                }
            }()
            layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: .spacingM, bottom: 0, trailing: .spacingM)
        case .recommendations(let viewModel):
            layoutSection = NSCollectionLayoutSection.staggered(with: viewModel.items, traitCollection: .current)
            title = viewModel.title
            layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        }

        layoutSection.supplementariesFollowContentInsets = false

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(58)
            ),
            elementKind: elementKind,
            alignment: .top
        )
        header.contentInsets.leading = .spacingM

        if title != nil {
            layoutSection.boundarySupplementaryItems = [header]
        }

        return layoutSection
    }
}

// MARK: - Layout section

private extension NSCollectionLayoutSection {
    static let twoRowsGrid: NSCollectionLayoutSection = {
        let size: CGFloat = 128
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .absolute(size),
            heightDimension: .absolute(size)
        ))
        item.contentInsets = .zero

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(size),
                heightDimension: .absolute(size * 2 + .spacingM)
            ),
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(.spacingM)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = .spacingM
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: .spacingM, bottom: 0, trailing: .spacingM)
        return section
    }()

    static var hero = horizontalLayout(
        size: NSCollectionLayoutSize(
            widthDimension: .absolute(284),
            heightDimension: .absolute(201)
        ),
        scrollingBehavior: .groupPaging
    )

    static let squares = horizontalLayout(
        size: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 2),
            heightDimension: .fractionalWidth(1 / 2)
        ),
        scrollingBehavior: .continuous
    )
    
    static let banner = {
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(140)
            ),
            subitem: NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(140))
            ),
            count: 1
        )
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = .spacingM
        return section
    }()


    static func horizontalLayout(
        size: NSCollectionLayoutSize,
        scrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior
    ) -> NSCollectionLayoutSection {
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: size,
            subitem: NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0))
            ),
            count: 1
        )
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = .spacingM
        section.orthogonalScrollingBehavior = scrollingBehavior
        return section
    }
}

// MARK: - Private extensions

extension ExploreRecommendationAdViewModel: StaggeredLayoutItem {
    public var staggeredLayoutItemKind: StaggeredLayoutItemKind { .compact }

    public func staggeredLayoutItemHeight(forWidth width: CGFloat) -> StaggeredLayoutItemHeight {
        return .dynamic(
            aspectRatio: imageSize.width / imageSize.height,
            extraHeight: StandardAdRecommendationCell.extraHeight()
        )
    }
}
