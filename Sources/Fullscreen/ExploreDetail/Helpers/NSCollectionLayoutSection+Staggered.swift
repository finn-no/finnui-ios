//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

// MARK: - Protocols

public enum StaggeredLayoutItemKind {
    case compact
    case fullWidth
}

public enum StaggeredLayoutItemHeight {
    case dynamic(aspectRatio: CGFloat?, extraHeight: CGFloat)
    case fixed(CGFloat)
}

public protocol StaggeredLayoutItem {
    var staggeredLayoutItemKind: StaggeredLayoutItemKind { get }
    func staggeredLayoutItemHeight(forWidth width: CGFloat) -> StaggeredLayoutItemHeight
}

// MARK: - Staggered layout

public extension NSCollectionLayoutSection {
    static func staggered(with models: [StaggeredLayoutItem], traitCollection: UITraitCollection) -> NSCollectionLayoutSection {
        let configuration = GridLayoutConfiguration(traitCollection: traitCollection)
        let contentWidth = UIScreen.main.bounds.size.width
        let columnItemWidth = configuration.itemWidth(for: contentWidth)
        var items = [NSCollectionLayoutGroupCustomItem]()
        let columnsRange = 0 ..< configuration.numberOfColumns
        var columns = columnsRange.map { _ in 0 }

        for model in models {
            let frame: CGRect

            switch model.staggeredLayoutItemKind {
            case .compact:
                let columnIndex = configuration.indexOfLowestValue(in: columns)
                let xOffset = configuration.xOffsetForItemInColumn(
                    itemWidth: columnItemWidth,
                    columnIndex: columnIndex
                )
                let yOffset = CGFloat(columns[columnIndex])
                let itemHeight = self.itemHeight(model: model, itemWidth: columnItemWidth)
                frame = CGRect(x: xOffset, y: yOffset, width: columnItemWidth, height: itemHeight)
                columns[columnIndex] = Int(frame.maxY + configuration.columnSpacing)
            case .fullWidth:
                let columnIndex = configuration.indexOfHighestValue(in: columns)
                let xOffset = configuration.sidePadding
                let yOffset = CGFloat(columns[columnIndex])
                let itemWidth = contentWidth - configuration.sidePadding * 2
                let itemHeight = self.itemHeight(model: model, itemWidth: itemWidth)
                frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: itemHeight)
                columnsRange.forEach {
                    columns[$0] = Int(frame.maxY + configuration.columnSpacing)
                }
            }

            items.append(NSCollectionLayoutGroupCustomItem(frame: frame))
        }

        let absoluteHeight = models.count > 0
            ? (items.max(by: { $0.frame.maxY < $1.frame.maxY })?.frame.maxY ?? 0) + configuration.columnSpacing
            : 100

        let group = NSCollectionLayoutGroup.custom(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(absoluteHeight)
            ),
            itemProvider: { environment -> [NSCollectionLayoutGroupCustomItem] in
                return items
            })

        return NSCollectionLayoutSection(group: group)
    }

    private static func itemHeight(model: StaggeredLayoutItem, itemWidth: CGFloat) -> CGFloat {
        switch model.staggeredLayoutItemHeight(forWidth: itemWidth) {
        case .dynamic(let aspectRatio, let extraHeight):
            let aspectRatio = aspectRatio ?? 1
            let imageAspectRatio = min(max(aspectRatio, .minImageAspectRatio), .maxImageAspectRatio)
            return itemWidth / imageAspectRatio + extraHeight
        case .fixed(let height):
            return height
        }
    }
}

// MARK: - Configuration

private struct GridLayoutConfiguration {
    init(traitCollection: UITraitCollection) {
        var columns = traitCollection.horizontalSizeClass == .regular ? 3 : 2
        if (traitCollection.preferredContentSizeCategory.isAccessibilityCategory && Config.isDynamicTypeEnabled){
            columns -= 1
        }
        numberOfColumns = columns
    }
    
    let numberOfColumns: Int
    let sidePadding: CGFloat = .spacingM
    let lineSpacing: CGFloat = .spacingM
    let columnSpacing: CGFloat = .spacingM

    func itemWidth(for collectionViewWidth: CGFloat) -> CGFloat {
        let columnPadding = columnSpacing * CGFloat(numberOfColumns - 1)
        let sidePadding = self.sidePadding * 2
        let totalPadding = columnPadding + sidePadding
        let columnsWidth = collectionViewWidth - totalPadding
        return columnsWidth / CGFloat(numberOfColumns)
    }

    func xOffsetForItemInColumn(itemWidth: CGFloat, columnIndex: Int) -> CGFloat {
        (columnSpacing * CGFloat(columnIndex)) + (itemWidth * CGFloat(columnIndex)) + sidePadding
    }

    func indexOfLowestValue(in columns: [Int]) -> Int {
        columns.firstIndex(of: columns.min() ?? 0) ?? 0
    }

    func indexOfHighestValue(in columns: [Int]) -> Int {
        columns.firstIndex(of: columns.max() ?? 0) ?? 0
    }
}

// MARK: - Private extensions

private extension CGFloat {
    static let minImageAspectRatio: CGFloat = 0.75
    static let maxImageAspectRatio: CGFloat = 1.5
}
