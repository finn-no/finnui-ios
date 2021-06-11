//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

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
    static func staggered(with models: [StaggeredLayoutItem]) -> NSCollectionLayoutSection {
        let estimatedHeight = models.count > 0
            ? UIScreen.main.bounds.size.width / 2 * .minImageAspectRatio * CGFloat(models.count) / 2
            : 100

        let groupLayoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedHeight)
        )

        let group = NSCollectionLayoutGroup.custom(
            layoutSize: groupLayoutSize,
            itemProvider: { environment -> [NSCollectionLayoutGroupCustomItem] in
                let contentWidth = environment.container.contentSize.width
                let configuration = GridLayoutConfiguration(width: contentWidth)
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
                        let yOffset = CGFloat(columns[columnIndex]) + configuration.topOffset
                        let itemHeight = self.itemHeight(model: model, itemWidth: columnItemWidth)
                        frame = CGRect(x: xOffset, y: yOffset, width: columnItemWidth, height: itemHeight)
                        columns[columnIndex] = Int(frame.maxY + configuration.columnSpacing)
                    case .fullWidth:
                        let columnIndex = configuration.indexOfHighestValue(in: columns)
                        let xOffset = configuration.sidePadding
                        let yOffset = CGFloat(columns[columnIndex]) + configuration.topOffset
                        let itemWidth = contentWidth - configuration.sidePadding * 2
                        let itemHeight = self.itemHeight(model: model, itemWidth: itemWidth)
                        frame = CGRect(x: xOffset, y: yOffset, width: itemWidth, height: itemHeight)
                        columnsRange.forEach {
                            columns[$0] = Int(frame.maxY + configuration.columnSpacing)
                        }
                    }

                    items.append(NSCollectionLayoutGroupCustomItem(frame: frame))
                }

                return items
            })

        return NSCollectionLayoutSection(group: group)
    }

    private static func itemHeight(model: StaggeredLayoutItem, itemWidth: CGFloat) -> CGFloat {
        switch model.staggeredLayoutItemHeight(forWidth: itemWidth) {
        case .dynamic(let aspectRatio, let extraHeight):
            let aspectRatio = aspectRatio ?? .minImageAspectRatio
            let imageAspectRatio = min(max(aspectRatio, .minImageAspectRatio), .maxImageAspectRatio)
            return itemWidth / imageAspectRatio + extraHeight
        case .fixed(let height):
            return height
        }
    }
}

// MARK: - Configuration

private enum GridLayoutConfiguration {
    case small
    case medium
    case large

    static let mediumRange: Range<CGFloat> = (375.0 ..< 450.0)

    init(width: CGFloat) {
        switch width {
        case let width where width > GridLayoutConfiguration.mediumRange.upperBound:
            self = .large
        case let width where width < GridLayoutConfiguration.mediumRange.lowerBound:
            self = .small
        default:
            self = .medium
        }
    }

    var topOffset: CGFloat {
        switch self {
        case .large:
            return 10
        default:
            return 0
        }
    }

    var sidePadding: CGFloat { 16 }
    var lineSpacing: CGFloat { 16 }
    var columnSpacing: CGFloat { 16 }
    var numberOfColumns: Int { 2 }

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
    static let minImageAspectRatio: CGFloat = 1
    static let maxImageAspectRatio: CGFloat = 1.5
}
