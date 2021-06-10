//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

public protocol TagCloudGridViewDelegate: AnyObject {
    func tagCloudGridView(
        _ view: TagCloudGridView,
        didSelectItem item: TagCloudCellViewModel,
        at indexPath: IndexPath
    )
}

public final class TagCloudGridView: UIView, UICollectionViewDelegate {

    // MARK: - Static properties

    public static func height(for items: [TagCloudCellViewModel]) -> CGFloat {
        let builder = TagCloudLayoutBuilder(models: items)
        return builder.groupLayoutSize(forItems: builder.layoutGroupItems()).height
    }

    public static func collectionLayoutGroup(with models: [TagCloudCellViewModel]) -> NSCollectionLayoutGroup {
        NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(height(for: models))
            ),
            subitem: NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0))
            ),
            count: 1
        )
    }

    // MARK: - Public properties

    public weak var delegate: TagCloudGridViewDelegate?
    public weak var remoteImageViewDataSource: RemoteImageViewDataSource?
    public var onSelect: ((TagCloudCellViewModel, IndexPath) -> Void)?

    public var collectionViewOffset: CGFloat {
        get {
            collectionView.contentOffset.x
        }
        set {
            collectionView.contentOffset.x = newValue
        }
    }

    // MARK: - Private properties

    private var items = [TagCloudCellViewModel]()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: bounds,
            collectionViewLayout: UICollectionViewCompositionalLayout { [weak self] _, _  in
                TagCloudLayoutBuilder(models: self?.items ?? []).layoutSection()
            }
        )
        collectionView.contentInset.left = .spacingM
        collectionView.contentInset.right = .spacingM
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = false
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        collectionView.register(TagCloudCell.self)
        return collectionView
    }()

    private lazy var dataSource = UICollectionViewDiffableDataSource<Int, TagCloudCellViewModel>(
        collectionView: collectionView,
        cellProvider: { [weak self] collectionView, indexPath, viewModel in
            let cell = collectionView.dequeue(TagCloudCell.self, for: indexPath)
            cell.remoteImageViewDataSource = self?.remoteImageViewDataSource
            cell.configure(with: viewModel)
            return cell
        })

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    public func configure(withItems items: [TagCloudCellViewModel]) {
        self.items = items
        var snapshot = NSDiffableDataSourceSnapshot<Int, TagCloudCellViewModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func setup() {
        addSubview(collectionView)
        collectionView.fillInSuperview()
    }

    // MARK: - UICollectionViewDelegate

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = items[indexPath.item]
        delegate?.tagCloudGridView(self, didSelectItem: model, at: indexPath)
        onSelect?(model, indexPath)
    }
}

// MARK: - Layout builder

private struct TagCloudLayoutBuilder {
    let models: [TagCloudCellViewModel]
    private let spacing: CGFloat = .spacingS

    func layoutSection() -> NSCollectionLayoutSection {
        let items = layoutGroupItems()
        let layoutSize = groupLayoutSize(forItems: items)
        let group = NSCollectionLayoutGroup.custom(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(layoutSize.width),
                heightDimension: .absolute(layoutSize.height)
            ),
            itemProvider: { _ -> [NSCollectionLayoutGroupCustomItem] in
                return items
            })
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .zero
        return section
    }

    func layoutGroupItems() -> [NSCollectionLayoutGroupCustomItem] {
        var items = [NSCollectionLayoutGroupCustomItem]()
        var offset: CGPoint = .zero

        for (index, row) in createRows().enumerated() {
            offset.x = 0
            offset.y = (TagCloudCell.height + spacing) * CGFloat(index)

            for width in row {
                let frame = CGRect(x: offset.x, y: offset.y, width: width, height: TagCloudCell.height)
                offset.x += width + spacing
                items.append(NSCollectionLayoutGroupCustomItem(frame: frame))
            }
        }

        return items
    }

    func groupLayoutSize(forItems items: [NSCollectionLayoutGroupCustomItem]) -> CGSize {
        guard let last = items.last else {
            return .zero
        }

        return CGSize(
            width: items.max(by: { $0.frame.maxX < $1.frame.maxX })?.frame.maxX ?? UIScreen.main.bounds.size.width,
            height: last.frame.maxY
        )
    }

    // Algorithm is based on https://stackoverflow.com/a/35518541
    private func createRows() -> [[CGFloat]] {
        let widths = models.map({ TagCloudCell.width(for: $0) })
        let totalSum = widths.reduce(0, +)
        let estimatedRowWidth = UIScreen.main.bounds.size.width * 2.5
        let numberOfRows = Int(min(3, (totalSum / estimatedRowWidth).rounded(.up)))
        var avgSum = totalSum / CGFloat(numberOfRows)
        var results = [[CGFloat]]()
        var rowSum: CGFloat = 0
        var sumOfSeen: CGFloat = 0
        var row = [CGFloat]()

        for (index, width) in widths.enumerated() {
            if numberOfRows - results.count == 1 {
                row.append(contentsOf: widths[index..<widths.count])
                results.append(row)
                break
            }

            let leftCount = numberOfRows - results.count

            if leftCount > widths.count - index {
                if !row.isEmpty {
                    results.append(row)
                }
                results.append(contentsOf: [Array(widths[index..<widths.count])])
                break
            }

            sumOfSeen += width

            if rowSum < avgSum {
                row.append(width)
                rowSum += width
            } else {
                avgSum = (totalSum - sumOfSeen) / CGFloat((leftCount - 1))
                rowSum = width
                results.append(row)
                row = [width]
            }
        }

        return results
    }
}
