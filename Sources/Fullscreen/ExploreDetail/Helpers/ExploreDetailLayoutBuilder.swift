//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

struct ExploreDetailLayoutBuilder {
    let elementKind: String

    func collectionLayoutSection(
        for section: ExploreDetailViewModel.Section,
        at sectionIndex: Int
    ) -> NSCollectionLayoutSection {
        let headerId = UICollectionView.elementKindSectionHeader

        switch section.items {
        case .collections(let collections):
            let layoutSection: NSCollectionLayoutSection = collections.count > 5 ? .twoRowsGrid : .carouselSection
            if section.title != nil {
                layoutSection.boundarySupplementaryItems = [.header(with: headerId, height: .absolute(49))]
            }
            return layoutSection
        case .ads(let ads):
            let layoutSection = NSCollectionLayoutSection.staggered(with: ads)

            if sectionIndex == 0 {
                layoutSection.contentInsets.top = .spacingL
            } else {
                layoutSection.boundarySupplementaryItems = [.header(with: headerId, height: .absolute(68))]
            }

            return layoutSection
        }
    }
}

// MARK: - Layout

private extension NSCollectionLayoutSection {
    static let twoRowsGrid: NSCollectionLayoutSection = {
        let size = CGSize(width: 128, height: 96)
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .absolute(size.width),
            heightDimension: .absolute(size.height)
        ))
        item.contentInsets = .zero

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(size.width),
                heightDimension: .absolute(size.height * 2 + .spacingM)
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

    static var carouselSection: NSCollectionLayoutSection {
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(140),
                heightDimension: .absolute(96)
            ),
            subitem: NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0))
            ),
            count: 1
        )

        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: .spacingS, bottom: 0, trailing: 0)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: .spacingXS)

        return section
    }
}

private extension NSCollectionLayoutBoundarySupplementaryItem {
    static func header(
        with elementKind: String,
        height: NSCollectionLayoutDimension
    ) -> NSCollectionLayoutBoundarySupplementaryItem {
        NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: height),
            elementKind: elementKind,
            alignment: .top
        )
    }
}

// MARK: - Private extensions

extension ExploreAdCellViewModel: StaggeredLayoutItem {
    public var staggeredLayoutItemKind: StaggeredLayoutItemKind { .compact }

    public func staggeredLayoutItemHeight(forWidth width: CGFloat) -> StaggeredLayoutItemHeight {
        .dynamic(
            aspectRatio: aspectRatio,
            extraHeight: ExploreAdCell.textBlockHeight(for: self, width: width)
        )
    }
}
