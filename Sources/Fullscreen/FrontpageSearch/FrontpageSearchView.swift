import UIKit
import FinniversKit
import Foundation

public protocol FrontpageSearchViewDelegate: AnyObject {
    func frontpageSearchView(didSelectFavoriteButton button: UIButton, forAdWithId: Int, cell: FrontpageSearchImageResultCollectionViewCell)
    func frontpageSearchView(_ view: FrontpageSearchView, didSelectResultAt indexPath: IndexPath, uuid: UUID)
    func frontpageSearchView(didTapEnableLocationButton button: UIButton)
    func frontpageSearchViewDidScroll()
}

public final class FrontpageSearchView: UIView {

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.backgroundColor = .bgPrimary

        collectionView.register(FrontpageSearchImageResultCollectionViewCell.self)
        collectionView.register(FrontpageSearchResultCell.self)
        collectionView.register(FrontpageSearchLocationPermissionCell.self)
        collectionView.register(FrontpageSearchMoreResultsCollectionViewCell.self)
        collectionView.register(FrontpageSearchSectionHeader.self, ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(FrontpageSearchSectionFooter.self, ofKind: UICollectionView.elementKindSectionFooter)
        return collectionView
    }()

    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            return Self.createFullWidthSection()
        }
        return layout
    }()

    private static func createFullWidthSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(78)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(0.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top
        )

        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(7.0))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize,
                                                                 elementKind: UICollectionView.elementKindSectionFooter,
                                                                 alignment: .bottom
        )
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header, footer]
        section.contentInsets = NSDirectionalEdgeInsets(
            vertical: 0,
            horizontal: Self.horizontalSpacing
        )
        return section
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<FrontpageSearchSection, FrontpageSearchGroupItem>
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
                switch item.groupType {
                case .searchResult:
                    switch item.displayType {
                    case .standard:
                        let cell = collectionView.dequeue(FrontpageSearchResultCell.self, for: indexPath)
                        cell.configure(with: item)
                        return cell
                    case .recommend, .myFindings, .companyProfile, .geo:
                        let cell = collectionView.dequeue(FrontpageSearchImageResultCollectionViewCell.self, for: indexPath)
                        cell.configure(with: item, remoteImageViewDataSource: self.remoteImageViewDataSource)
                        cell.delegate = self.delegate
                        return cell
                    case .myFindingsList:
                        // should return an image cell with a circular image - not yet implemented
                        let cell = collectionView.dequeue(FrontpageSearchImageResultCollectionViewCell.self, for: indexPath)
                        cell.configure(with: item, remoteImageViewDataSource: self.remoteImageViewDataSource)
                        return cell
                    }
                case .locationPermission:
                    let cell = collectionView.dequeue(FrontpageSearchLocationPermissionCell.self, for: indexPath)
                    cell.configure(with: item.title)
                    cell.delegate = self.delegate
                    return cell
                case .showMoreResults:
                    let cell = collectionView.dequeue(FrontpageSearchMoreResultsCollectionViewCell.self, for: indexPath)
                    cell.configure(with: item.title)
                    return cell
                }
            }
        )

        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            if kind == "UICollectionElementKindSectionHeader" {

                let view = collectionView.dequeue(
                    FrontpageSearchSectionHeader.self,
                    for: indexPath,
                    ofKind: UICollectionView.elementKindSectionHeader
                )
                guard let section = self?.sections[safe: indexPath.section] else {
                    view.configure()
                    return view
                }
                switch section {
                case .group(let group):
                    guard group.items.count > 0 else {
                        view.configure()
                        return view
                    }
                    view.configure(with: group.title)
                case .viewMoreResults(title: let title):
                    view.configure()
                case .locationPermission(title: let title):
                    view.configure()
                }
                return view
            } else if kind == "UICollectionElementKindSectionFooter" {
                let view = collectionView.dequeue(
                    FrontpageSearchSectionFooter.self,
                    for: indexPath,
                    ofKind: UICollectionView.elementKindSectionFooter
                )
                return view
            }
            return UICollectionReusableView()
        }
        return dataSource
    }()

    private var sections = [FrontpageSearchSection]()
    private typealias Snapshot = NSDiffableDataSourceSnapshot<FrontpageSearchSection, FrontpageSearchGroupItem>
    private weak var delegate: FrontpageSearchViewDelegate?
    private var remoteImageViewDataSource: RemoteImageViewDataSource

    // MARK: - Internal properties

    static let horizontalSpacing: CGFloat = .spacingS

    // MARK: - Init

    public init(
        withAutoLayout: Bool,
        delegate: FrontpageSearchViewDelegate?,
        remoteImageViewDataSource: RemoteImageViewDataSource
    ) {
        self.delegate = delegate
        self.remoteImageViewDataSource = remoteImageViewDataSource
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgTertiary
        addSubview(collectionView)
        collectionView.fillInSuperview(insets: UIEdgeInsets(top: .spacingM, leading: 0, bottom: 0, trailing: 0))
    }

    // MARK: - Snapshot management

    public func configure(with sections: [FrontpageSearchSection], delegate: FrontpageSearchViewDelegate?) {
        self.delegate = delegate
        self.sections = sections
        var snapshot = Snapshot()
        snapshot.appendSections(sections)

        for section in sections {
            switch section {
            case .group(let group):
                snapshot.appendItems(group.items, toSection: section)
            case .locationPermission(let item):
                snapshot.appendItems([item], toSection: section)
            case .viewMoreResults(let item):
                snapshot.appendItems([item], toSection: section)
            }
        }
        applySnapshot(snapshot)
    }

    private func applySnapshot(_ snapshot: Snapshot, animatingDifferences: Bool = true) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }
    }

    // MARK: - Favorite button handling
    public func toggleFavoriteButtonState(for adId: Int, favorited: Bool) {
        let cells = collectionView.visibleCells
        cells.forEach { cell in
            if let favoriteCell = cell as? FrontpageSearchImageResultCollectionViewCell {
                if favoriteCell.getAdIdForCell() == adId {
                    favoriteCell.updateFavoriteButton(isFavorite: favorited)
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension FrontpageSearchView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let result = dataSource.itemIdentifier(for: indexPath) {
            delegate?.frontpageSearchView(self, didSelectResultAt: indexPath, uuid: result.uuid)
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.frontpageSearchViewDidScroll()
    }
}

