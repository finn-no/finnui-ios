//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

struct ExploreLayoutBuilder {
    let elementKind: String

    var collectionViewLayout: UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            let section: NSCollectionLayoutSection = {
                let index = sectionIndex % 3

                if index == 0 {
                    return .grid
                } else if index == 1 {
                    return .hero
                } else if index == 2 {
                    return .smallSquares
                } else {
                    return .smallSquares
                }
            }()
            section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(70)
                ),
                elementKind: elementKind,
                alignment: .top
            )]

            section.supplementariesFollowContentInsets = false
            return section
        }
    }
}

// MARK: - Layout section

private extension NSCollectionLayoutSection {
    static let grid: NSCollectionLayoutSection = {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 2),
            heightDimension: .fractionalWidth(1 / 2)
        ))
        item.contentInsets = .zero

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1.0)
            ),
            subitem: item,
            count: 2
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = .spacingM
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: .spacingM, bottom: 0, trailing: .spacingM
        )
        return section
    }()

    static var hero = horizontalLayout(
        size: NSCollectionLayoutSize(
            widthDimension: .absolute(284),
            heightDimension: .absolute(201)
        ),
        scrollingBehavior: .groupPaging
    )

    static let smallSquares = horizontalLayout(
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: .spacingM, bottom: 0, trailing: .spacingXS)
        return section
    }
}

