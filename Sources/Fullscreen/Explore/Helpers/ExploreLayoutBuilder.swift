//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

struct ExploreLayoutBuilder {
    let elementKind: String

    func collectionLayoutSection(for section: ExploreSectionViewModel) -> NSCollectionLayoutSection {
        let layoutSection: NSCollectionLayoutSection = {
            switch section.layout {
            case .hero:
                return .hero
            case .squares:
                return .squares
            case .twoRowsGrid:
                return .twoRowsGrid
            case .tagCloud:
                let group = TagCloudGridView.collectionLayoutGroup(with: section.items)
                return NSCollectionLayoutSection(group: group)
            }
        }()

        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: .spacingM, bottom: 0, trailing: .spacingM)
        layoutSection.supplementariesFollowContentInsets = false

        layoutSection.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(58)
            ),
            elementKind: elementKind,
            alignment: .top
        )]

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
