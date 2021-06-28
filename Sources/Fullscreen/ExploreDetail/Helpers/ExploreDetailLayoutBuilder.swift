//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

struct ExploreDetailLayoutBuilder {
    let elementKind: String

    func collectionLayoutSection(
        for section: ExploreDetailSection,
        at sectionIndex: Int,
        traitCollection: UITraitCollection
    ) -> NSCollectionLayoutSection {
        let headerId = UICollectionView.elementKindSectionHeader

        switch section.items {
        case .collections(let collections):
            let layoutSection: NSCollectionLayoutSection = collections.count < 6 || traitCollection.horizontalSizeClass == .regular
                ? .carouselSection(itemSize: CGSize(width: 140, height: 96))
                : .twoRowsGrid
            if section.title != nil {
                layoutSection.boundarySupplementaryItems = [.header(with: headerId, height: .absolute(49))]
            }
            return layoutSection
        case .selectedCategories:
            let layoutSection: NSCollectionLayoutSection = .carouselSection(itemSize: CGSize(width: 104, height: 88))
            layoutSection.contentInsets.top = .spacingM
            if section.title != nil {
                layoutSection.boundarySupplementaryItems = [.header(with: headerId, height: .absolute(49))]
            }
            return layoutSection
        case .ads(let ads):
            let layoutSection = NSCollectionLayoutSection.staggered(with: ads, traitCollection: traitCollection)

            if sectionIndex == 0 {
                layoutSection.contentInsets.top = .spacingL
            } else {
                let header = NSCollectionLayoutBoundarySupplementaryItem.header(with: headerId, height: .absolute(68))
                header.contentInsets.leading = .spacingM
                layoutSection.boundarySupplementaryItems = [header]
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
                heightDimension: .absolute(size.height * 2 + .spacingS)
            ),
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(.spacingS)
        group.contentInsets = .zero

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = .spacingS
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: .spacingM, bottom: 0, trailing: .spacingM)
        return section
    }()

    static func carouselSection(itemSize: CGSize) -> NSCollectionLayoutSection {
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(itemSize.width),
                heightDimension: .absolute(itemSize.height)
            ),
            subitem: NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(itemSize.height))
            ),
            count: 1
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: .spacingM, bottom: 0, trailing: .spacingM)
        section.interGroupSpacing = .spacingS

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
